import 'package:cloud_firestore/cloud_firestore.dart';

class PusatAdabController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _submissionCollection = 'StudentSubmission';
  final String _gradingCollection = 'Grading';
  final String _activitiesCollection = 'Activity';

  // ==============================================
  // GRADE ACTIVITY METHODS
  // ==============================================

  /// Get modules with pending submissions (for GradeActivitiesPage)
  Future<List<Map<String, dynamic>>> getSubmittedActivitiesList() async {
    try {
      print("🔍 Fetching submitted activities for grading...");

      final QuerySnapshot snapshot = await _firestore
          .collection(_submissionCollection)
          .where('Status', isEqualTo: 'submitted')
          .get();

      print("📚 Found ${snapshot.docs.length} submissions");

      if (snapshot.docs.isEmpty) {
        return [];
      }

      Map<String, Map<String, dynamic>> moduleMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        String moduleCode = data['ModuleCode']?.toString() ?? 'Unknown';
        String moduleName = data['ModuleName']?.toString() ?? 'Unknown Module';

        if (!moduleMap.containsKey(moduleCode)) {
          moduleMap[moduleCode] = {
            'moduleId': moduleCode,
            'moduleCode': moduleCode,
            'moduleName': moduleName,
            'submissions': <Map<String, dynamic>>[],
            'pendingCount': 0,
          };
        }

        final gradingCheck = await _firestore
            .collection(_gradingCollection)
            .where('SubmissionID', isEqualTo: doc.id)
            .get();

        bool isGraded = gradingCheck.docs.isNotEmpty;

        final submission = {
          'submissionId': doc.id,
          'studentId': data['StudentID']?.toString() ?? '',
          'studentName': data['StudentName']?.toString() ?? 'Unknown Student',
          'activityName': data['ActivityName']?.toString() ?? '',
          'submissionDate': data['SubmissionDate'] != null
              ? _formatDate(data['SubmissionDate'])
              : '',
          'documentUrl': data['DocumentURL']?.toString() ?? '',
          'isGraded': isGraded,
        };

        moduleMap[moduleCode]!['submissions'].add(submission);

        if (!isGraded) {
          moduleMap[moduleCode]!['pendingCount'] =
              (moduleMap[moduleCode]!['pendingCount'] as int) + 1;
        }
      }

      List<Map<String, dynamic>> result = moduleMap.values.toList();
      result.sort((a, b) => (b['pendingCount'] as int).compareTo(a['pendingCount'] as int));

      print("✅ Returning ${result.length} modules with submissions");
      return result;
    } catch (e) {
      print("❌ Error fetching submissions: $e");
      return [];
    }
  }

  /// Get submissions for a specific module
  Future<List<Map<String, dynamic>>> getSubmissionsForModule(String moduleCode) async {
    try {
      print("🔍 Fetching submissions for module: $moduleCode");

      final QuerySnapshot snapshot = await _firestore
          .collection(_submissionCollection)
          .where('ModuleCode', isEqualTo: moduleCode)
          .where('Status', isEqualTo: 'submitted')
          .get();

      print("📚 Found ${snapshot.docs.length} submissions");

      List<Map<String, dynamic>> submissions = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final gradingSnapshot = await _firestore
            .collection(_gradingCollection)
            .where('SubmissionID', isEqualTo: doc.id)
            .get();

        bool isGraded = gradingSnapshot.docs.isNotEmpty;
        int? score;

        if (isGraded) {
          final gradingData = gradingSnapshot.docs.first.data() as Map<String, dynamic>?;
          if (gradingData != null) {
            score = gradingData['Score'] as int?;
          }
        }

        submissions.add({
          'submissionId': doc.id,
          'studentId': data['StudentID']?.toString() ?? '',
          'studentName': data['StudentName']?.toString() ?? 'Unknown Student',
          'activityName': data['ActivityName']?.toString() ?? '',
          'documentUrl': data['DocumentURL']?.toString() ?? '',
          'submissionDate': data['SubmissionDate'] != null
              ? _formatDate(data['SubmissionDate'])
              : '',
          'isGraded': isGraded,
          'score': score,
        });
      }

      print("✅ Returning ${submissions.length} submissions");
      return submissions;
    } catch (e) {
      print("❌ Error fetching submissions for module: $e");
      return [];
    }
  }

  /// Grade a submission - saves to Grading table and updates StudentSubmission
  Future<bool> validateAndUpdateScoreData(
    String submissionId,
    int score,
    String staffId,
  ) async {
    try {
      print("📝 Grading submission: $submissionId");
      print("📝 Score: $score, Staff: $staffId");

      if (score < 0 || score > 100) {
        print("❌ Invalid score: $score. Must be between 0-100.");
        return false;
      }

      // Get submission details
      final submissionDoc = await _firestore
          .collection(_submissionCollection)
          .doc(submissionId)
          .get();

      if (!submissionDoc.exists) {
        print("❌ Submission not found! ID: $submissionId");
        return false;
      }

      final submissionData = submissionDoc.data() as Map<String, dynamic>?;
      if (submissionData == null) {
        print("❌ Submission data is null!");
        return false;
      }

      print("📋 Submission data found:");
      print("   - Student: ${submissionData['StudentName']}");
      print("   - Module: ${submissionData['ModuleCode']}");
      print("   - Activity: ${submissionData['ActivityName']}");
      print("   - Current Status: ${submissionData['Status']}");

      // Step 1: Save to Grading table
      try {
        await _firestore.collection(_gradingCollection).add({
          'SubmissionID': submissionId,
          'StudentID': submissionData['StudentID']?.toString() ?? '',
          'StudentName': submissionData['StudentName']?.toString() ?? '',
          'ModuleCode': submissionData['ModuleCode']?.toString() ?? '',
          'ModuleName': submissionData['ModuleName']?.toString() ?? '',
          'ActivityName': submissionData['ActivityName']?.toString() ?? '',
          'Score': score,
          'Feedback': '',
          'GradedBy': staffId,
          'GradedDate': FieldValue.serverTimestamp(),
        });
        print("✅ Grade saved to Grading table");
      } catch (e) {
        print("❌ Failed to save to Grading table: $e");
        return false;
      }

      // Step 2: Update StudentSubmission status to 'graded'
      try {
        await _firestore
            .collection(_submissionCollection)
            .doc(submissionId)
            .update({
              'Status': 'graded',
            });
        print("✅ StudentSubmission status updated to 'graded'");
      } catch (e) {
        print("❌ Failed to update StudentSubmission: $e");
        return false;
      }

      // Step 3: Verify the update
      final verifyDoc = await _firestore
          .collection(_submissionCollection)
          .doc(submissionId)
          .get();
      
      if (verifyDoc.exists) {
        final verifyData = verifyDoc.data() as Map<String, dynamic>?;
        final newStatus = verifyData?['Status']?.toString() ?? 'unknown';
        print("✅ Verification - New Status: $newStatus");
        
        if (newStatus != 'graded') {
          print("❌ Verification failed! Status is still: $newStatus");
          return false;
        }
      }

      returnSaveConfirmation();
      return true;
    } catch (e) {
      print("❌ Error grading submission: $e");
      print("❌ Stack trace: ${StackTrace.current}");
      return false;
    }
  }

  /// View document
  Future<String> getViewDocument(String submissionId) async {
    try {
      final doc = await _firestore
          .collection(_submissionCollection)
          .doc(submissionId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return data['DocumentURL']?.toString() ?? 'No document available';
        }
      }
      return 'Document not found';
    } catch (e) {
      print("❌ Error viewing document: $e");
      return 'Error loading document';
    }
  }

  /// Download document
  Future<String> getDownloadDocument(String submissionId) async {
    try {
      final doc = await _firestore
          .collection(_submissionCollection)
          .doc(submissionId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return data['DocumentURL']?.toString() ?? '';
        }
      }
      return '';
    } catch (e) {
      print("❌ Error downloading document: $e");
      return '';
    }
  }

  // ==============================================
  // VERIFY CREDIT CLAIM METHODS
  // ==============================================

  Future<List<Map<String, dynamic>>> getCreditClaimsList() async {
    try {
      print("🔍 Fetching credit claims...");

      final QuerySnapshot snapshot = await _firestore
          .collection('CreditClaim')
          .where('Status', isEqualTo: 'pending')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      Map<String, Map<String, dynamic>> facultyMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        String faculty = data['StudentFaculty']?.toString() ?? 'Unknown Faculty';

        if (!facultyMap.containsKey(faculty)) {
          facultyMap[faculty] = {
            'facultyName': faculty,
            'pendingCount': 0,
            'claims': <Map<String, dynamic>>[],
          };
        }

        final claim = {
          'claimId': doc.id,
          'studentId': data['StudentID']?.toString() ?? '',
          'studentName': data['StudentName']?.toString() ?? 'Unknown Student',
          'studentFaculty': data['StudentFaculty']?.toString() ?? '',
          'credits': data['CreditsClaimed'] as int? ?? 1,
          'claimDate': data['ClaimDate'] != null
              ? _formatDate(data['ClaimDate'])
              : '',
          'status': data['Status']?.toString() ?? 'pending',
        };

        facultyMap[faculty]!['claims'].add(claim);
        facultyMap[faculty]!['pendingCount'] =
            (facultyMap[faculty]!['pendingCount'] as int) + 1;
      }

      return facultyMap.values.toList();
    } catch (e) {
      print("❌ Error fetching credit claims: $e");
      return [];
    }
  }

  Future<bool> validateAndUpdateClaimStatus(
    String claimId,
    String status,
    String staffId,
  ) async {
    try {
      if (status != 'approve' && status != 'reject') {
        return false;
      }

      await _firestore.collection('CreditClaim').doc(claimId).update({
        'Status': status,
        'VerifiedBy': staffId,
        'VerifiedDate': FieldValue.serverTimestamp(),
      });

      returnClaimConfirmation();
      return true;
    } catch (e) {
      print("❌ Error updating claim status: $e");
      return false;
    }
  }

  // ==============================================
  // HELPER METHODS
  // ==============================================

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return '';
  }

  void returnSubmittedActivitiesList(List<Map<String, dynamic>> list) {
    print("Submitted activities list sent to GradeActivitiesPage");
  }

  void returnViewDocument(String content) {
    print("Document content sent to ViewDocumentPage");
  }

  void returnDownloadDocument(String file) {
    print("Document file sent to GradeActivitiesListPage");
  }

  void returnSaveConfirmation() {
    print("Grade submitted successfully");
  }

  void returnCreditClaimsList(List<Map<String, dynamic>> list) {
    print("Credit claims list sent to VerifyCreditPage");
  }

  void returnClaimConfirmation() {
    print("Claim status updated successfully");
  }
}