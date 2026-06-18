import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Domain/ManageCurriculumCoCurriculumActivities/CurriculumModulesModel.dart';

class StudentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Static list for registered modules
  static List<CurriculumModulesModel> _registeredModulesList = [];

  final String _modulesCollection = 'CurriculumModule';
  final String _registeredCollection = 'RegisteredModule';
  final String _activitiesCollection = 'Activity';
  final String _creditClaimsCollection = 'CreditClaim';
  final String _submissionCollection = 'StudentSubmission';
  final String _gradingCollection = 'Grading';

  // ==============================================
  // MODULE BOOKING METHODS
  // ==============================================

  /// Get all available modules from CurriculumModule collection
  Future<List<CurriculumModulesModel>> getAvailableSubjects() async {
    try {
      print('========== FETCHING MODULES ==========');

      QuerySnapshot snapshot = await _firestore
          .collection(_modulesCollection)
          .get();

      print('✅ Found ${snapshot.docs.length} documents');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<CurriculumModulesModel> modules = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        String moduleCode = data['ModuleCode']?.toString() ?? 'UNKNOWN';
        String moduleName = data['ModuleName']?.toString() ?? 'UNKNOWN';

        print('📚 $moduleCode - $moduleName');

        List<Map<String, dynamic>> scheduleSlots = [];

        if (data['scheduleSlots'] != null && data['scheduleSlots'] is List) {
          List slots = data['scheduleSlots'] as List;
          for (var slot in slots) {
            if (slot is Map<String, dynamic>) {
              scheduleSlots.add({
                'date': slot['date']?.toString() ?? 'N/A',
                'venue': slot['venue']?.toString() ?? 'N/A',
                'startTime': slot['startTime']?.toString() ?? 'N/A',
                'endTime': slot['endTime']?.toString() ?? 'N/A',
              });
            }
          }
        }

        modules.add(
          CurriculumModulesModel(
            ModuleID: doc.id,
            ModuleCode: moduleCode,
            ModuleName: moduleName,
            scheduleSlots: scheduleSlots,
          ),
        );
      }

      modules.sort((a, b) => a.ModuleCode.compareTo(b.ModuleCode));

      print('========== RETURNING ${modules.length} MODULES ==========');
      return modules;
    } catch (e) {
      print('❌ ERROR: $e');
      return [];
    }
  }

  /// Validate if student can register for a module
  Future<bool> validateRegistrationData(
    String StudentID,
    String ModuleID,
  ) async {
    try {
      QuerySnapshot existing = await _firestore
          .collection(_registeredCollection)
          .where('StudentID', isEqualTo: StudentID)
          .where('ModuleID', isEqualTo: ModuleID)
          .where('Status', isEqualTo: 'active')
          .get();

      if (existing.docs.isNotEmpty) {
        print('❌ Already registered');
        return false;
      }

      return true;
    } catch (e) {
      print('❌ Error validating: $e');
      return false;
    }
  }

  /// Save registration data to Firebase
  Future<void> saveRegistrationData(
    String StudentID,
    String ModuleID,
    CurriculumModulesModel module,
  ) async {
    try {
      bool alreadyExists = _registeredModulesList.any(
        (m) => m.ModuleID == module.ModuleID,
      );

      if (!alreadyExists) {
        _registeredModulesList.add(module);

        await _firestore.collection(_registeredCollection).add({
          'StudentID': StudentID,
          'ModuleID': ModuleID,
          'ModuleCode': module.ModuleCode,
          'ModuleName': module.ModuleName,
          'RegisteredDate': FieldValue.serverTimestamp(),
          'Status': 'active',
        });

        print('✅ Module registered successfully');
        print('📋 ModuleCode: ${module.ModuleCode}');
      }
    } catch (e) {
      print('❌ Error saving: $e');
      throw Exception('Failed to register module: $e');
    }
  }

  /// Get registered subjects for a student
  Future<List<CurriculumModulesModel>> getRegisteredSubjects(
    String StudentID,
  ) async {
    try {
      print('Fetching registered modules for Student: $StudentID');

      QuerySnapshot snapshot = await _firestore
          .collection(_registeredCollection)
          .where('StudentID', isEqualTo: StudentID)
          .where('Status', isEqualTo: 'active')
          .get();

      print('Found ${snapshot.docs.length} registered modules');

      List<CurriculumModulesModel> registeredModules = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Get module details from CurriculumModule collection
        DocumentSnapshot moduleDoc = await _firestore
            .collection(_modulesCollection)
            .doc(data['ModuleID'])
            .get();

        if (moduleDoc.exists) {
          var moduleData = moduleDoc.data() as Map<String, dynamic>;

          // Get schedule slots
          List<Map<String, dynamic>> scheduleSlots = [];

          if (moduleData['scheduleSlots'] != null &&
              moduleData['scheduleSlots'] is List) {
            List slots = moduleData['scheduleSlots'] as List;
            for (var slot in slots) {
              if (slot is Map<String, dynamic>) {
                scheduleSlots.add({
                  'date': slot['date']?.toString() ?? 'N/A',
                  'venue': slot['venue']?.toString() ?? 'N/A',
                  'startTime': slot['startTime']?.toString() ?? 'N/A',
                  'endTime': slot['endTime']?.toString() ?? 'N/A',
                });
              }
            }
          } else {
            scheduleSlots.add({
              'date': moduleData['classDate']?.toString() ?? 'N/A',
              'venue': moduleData['venue']?.toString() ?? 'N/A',
              'startTime': moduleData['startTime']?.toString() ?? 'N/A',
              'endTime': moduleData['endTime']?.toString() ?? 'N/A',
            });
          }

          registeredModules.add(
            CurriculumModulesModel(
              ModuleID: data['ModuleID'],
              ModuleCode:
                  moduleData['ModuleCode']?.toString() ??
                  data['ModuleCode']?.toString() ??
                  '',
              ModuleName:
                  moduleData['ModuleName']?.toString() ??
                  data['ModuleName']?.toString() ??
                  '',
              scheduleSlots: scheduleSlots,
            ),
          );
        }
      }

      // Update static list
      _registeredModulesList = registeredModules;
      print("Returning ${_registeredModulesList.length} registered modules");
      return List.from(_registeredModulesList);
    } catch (e) {
      print('Error fetching registered subjects: $e');
      return [];
    }
  }

  /// Drop a subject (delete registration)
  Future<void> dropSubject(String ModuleID) async {
    try {
      print('Dropping module: $ModuleID');

      // Find the registration and delete it
      QuerySnapshot snapshot = await _firestore
          .collection(_registeredCollection)
          .where('ModuleID', isEqualTo: ModuleID)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection(_registeredCollection).doc(doc.id).delete();
        print('Deleted registration document: ${doc.id}');
      }

      // Remove from local list
      _registeredModulesList.removeWhere(
        (module) => module.ModuleID == ModuleID,
      );
      print("Module dropped: $ModuleID");
    } catch (e) {
      print('Error dropping module: $e');
      throw Exception('Failed to drop module: $e');
    }
  }

  // ==============================================
  // ACTIVITY METHODS (3-TABLE DESIGN)
  // ==============================================

  /// Get assigned activities for the student's registered modules
  Future<List<Map<String, dynamic>>> getAssignedActivities(
    String studentID,
  ) async {
    try {
      print("🔍 Fetching activities for student: $studentID");

      // Step 1: Get all modules the student is registered for
      final QuerySnapshot registeredModules = await _firestore
          .collection(_registeredCollection)
          .where('StudentID', isEqualTo: studentID)
          .where('Status', isEqualTo: 'active')
          .get();

      print("📚 Found ${registeredModules.docs.length} registered modules");

      if (registeredModules.docs.isEmpty) {
        print("⚠️ No registered modules found");
        return [];
      }

      // Step 2: Get all ModuleCodes the student is registered for
      List<String> registeredModuleCodes = [];

      for (var doc in registeredModules.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String moduleCode = data['ModuleCode'] ?? '';
        if (moduleCode.isNotEmpty) {
          registeredModuleCodes.add(moduleCode);
          print("📋 Registered Module Code: $moduleCode");
        }
      }

      print("📋 Total Registered Module Codes: $registeredModuleCodes");

      // Step 3: Get activities for the student from Activity table
      final QuerySnapshot activitiesSnapshot = await _firestore
          .collection(_activitiesCollection)
          .where('StudentID', isEqualTo: studentID)
          .get();

      print(
        "📋 Found ${activitiesSnapshot.docs.length} activities for student",
      );

      List<Map<String, dynamic>> activities = [];

      // Step 4: Filter activities - only include if module is registered
      for (var doc in activitiesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String moduleCode = data['ModuleCode'] ?? '';

        if (registeredModuleCodes.contains(moduleCode)) {
          print("✅ Activity found for registered module: $moduleCode");

          // Check if student already submitted this activity
          final submissionSnapshot = await _firestore
              .collection(_submissionCollection)
              .where('StudentID', isEqualTo: studentID)
              .where('ActivityID', isEqualTo: doc.id)
              .get();

          // Default status is 'not_started' (not submitted yet)
          String status = 'not_started';
          String? submissionId;
          String? documentUrl;
          int? score;

          if (submissionSnapshot.docs.isNotEmpty) {
            final submissionData =
                submissionSnapshot.docs.first.data() as Map<String, dynamic>;
            status = submissionData['Status'] ?? 'submitted';
            submissionId = submissionSnapshot.docs.first.id;
            documentUrl = submissionData['DocumentURL'];

            // Check if graded - look in Grading table for score
            if (status == 'graded') {
              final gradingSnapshot = await _firestore
                  .collection(_gradingCollection)
                  .where('SubmissionID', isEqualTo: submissionId)
                  .get();
              if (gradingSnapshot.docs.isNotEmpty) {
                final gradingData =
                    gradingSnapshot.docs.first.data() as Map<String, dynamic>;
                score = gradingData['Score'] as int?;
              }
            }
          }

          activities.add({
            'id': doc.id,
            'moduleCode': data['ModuleCode'] ?? '',
            'moduleName': data['ModuleName'] ?? '',
            'activityName': data['ActivityName'] ?? '',
            'description': data['description'] ?? '',
            'instructions': data['instructions'] ?? '',
            'openedDate': data['openedDate'] ?? '',
            'dueDate': data['dueDate'] ?? '',
            'status': status,
            'submissionId': submissionId,
            'documentUrl': documentUrl,
            'score': score,
          });
        } else {
          print("⏭️ Skipping activity for module not registered: $moduleCode");
        }
      }

      print(
        "✅ Returning ${activities.length} activities for registered modules",
      );
      print("📊 Statuses: ${activities.map((a) => a['status']).toList()}");
      return activities;
    } catch (e) {
      print("❌ Error getting activities: $e");
      return [];
    }
  }

  /// Submit activity - saves to StudentSubmission table
  Future<bool> submitActivity(
    String studentID,
    String studentName,
    String activityId,
    String documentURL,
    String description,
  ) async {
    try {
      // Get activity details
      final activityDoc = await _firestore
          .collection(_activitiesCollection)
          .doc(activityId)
          .get();

      if (!activityDoc.exists) {
        print("❌ Activity not found");
        return false;
      }

      final activityData = activityDoc.data() as Map<String, dynamic>;

      // Create submission in StudentSubmission table
      await _firestore.collection(_submissionCollection).add({
        'StudentID': studentID,
        'StudentName': studentName,
        'ActivityID': activityId,
        'ModuleCode': activityData['ModuleCode'] ?? '',
        'ModuleName': activityData['ModuleName'] ?? '',
        'ActivityName': activityData['ActivityName'] ?? '',
        'DocumentURL': documentURL,
        'Description': description,
        'SubmissionDate': FieldValue.serverTimestamp(),
        'Status': 'submitted',
      });

      print("✅ Activity submitted successfully!");
      return true;
    } catch (e) {
      print("❌ Error submitting activity: $e");
      return false;
    }
  }

  /// Get student submissions
  Future<List<Map<String, dynamic>>> getStudentSubmissions(
    String studentID,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_submissionCollection)
          .where('StudentID', isEqualTo: studentID)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'submissionId': doc.id,
          'activityId': data['ActivityID'] ?? '',
          'moduleCode': data['ModuleCode'] ?? '',
          'moduleName': data['ModuleName'] ?? '',
          'activityName': data['ActivityName'] ?? '',
          'documentUrl': data['DocumentURL'] ?? '',
          'description': data['Description'] ?? '',
          'submissionDate': data['SubmissionDate'],
          'status': data['Status'] ?? 'submitted',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // ==============================================
  // CREDIT CLAIM METHODS
  // ==============================================

  /// Get claimable modules (graded submissions not yet claimed)
  Future<List<Map<String, dynamic>>> getClaimableModules(
    String studentID,
  ) async {
    try {
      print("📋 Fetching claimable modules for student: $studentID");

      // Step 1: Get all graded submissions for this student
      final QuerySnapshot gradedSubmissions = await _firestore
          .collection(_submissionCollection)
          .where('StudentID', isEqualTo: studentID)
          .where('Status', isEqualTo: 'graded')
          .get();

      print("📚 Found ${gradedSubmissions.docs.length} graded submissions");

      if (gradedSubmissions.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> claimableModules = [];

      // Step 2: For each graded submission, check if credit already claimed
      for (var doc in gradedSubmissions.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String moduleCode = data['ModuleCode'] ?? '';
        String moduleName = data['ModuleName'] ?? '';
        String activityName = data['ActivityName'] ?? '';

        // Check if already claimed
        final claimCheck = await _firestore
            .collection(_creditClaimsCollection)
            .where('StudentID', isEqualTo: studentID)
            .where('ModuleCode', isEqualTo: moduleCode)
            .get();

        String claimStatus = 'not_claimed';
        String? claimId;

        if (claimCheck.docs.isNotEmpty) {
          final claimData =
              claimCheck.docs.first.data() as Map<String, dynamic>;
          claimStatus = claimData['Status'] ?? 'pending';
          claimId = claimCheck.docs.first.id;
        }

        // Get credits from module
        int credits = 1;
        try {
          final moduleDoc = await _firestore
              .collection(_modulesCollection)
              .where('ModuleCode', isEqualTo: moduleCode)
              .get();
          if (moduleDoc.docs.isNotEmpty) {
            final moduleData =
                moduleDoc.docs.first.data() as Map<String, dynamic>;
            credits = moduleData['credits'] as int? ?? 1;
          }
        } catch (e) {
          print("Could not fetch credits for module: $moduleCode");
        }

        // Get grade from Grading table
        final gradingSnapshot = await _firestore
            .collection(_gradingCollection)
            .where('SubmissionID', isEqualTo: doc.id)
            .get();

        int? score;
        if (gradingSnapshot.docs.isNotEmpty) {
          final gradingData =
              gradingSnapshot.docs.first.data() as Map<String, dynamic>;
          score = gradingData['Score'] as int?;
        }

        claimableModules.add({
          'id': data['ModuleID'] ?? '',
          'moduleCode': moduleCode,
          'moduleName': moduleName,
          'activityName': activityName,
          'credits': credits,
          'score': score,
          'claimStatus': claimStatus,
          'claimId': claimId,
          'submissionId': doc.id,
        });
      }

      print("✅ Returning ${claimableModules.length} claimable modules");
      return claimableModules;
    } catch (e) {
      print("❌ Error fetching claimable modules: $e");
      return [];
    }
  }

  /// Submit credit claim - saves student name and faculty
  Future<bool> submitCreditClaim(
    String studentID,
    String moduleCode,
    int credits,
  ) async {
    try {
      print("📝 Submitting credit claim for student: $studentID");
      print("📝 Module: $moduleCode, Credits: $credits");

      // Get student name and faculty
      String studentName = '';
      String studentFaculty = '';

      try {
        final studentDoc = await _firestore
            .collection('Student')
            .doc(studentID)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          
          // 🔴 FIX: Use the actual field names from your Student table
          studentName = studentData['MatricID']?.toString() ?? 
                        studentData['name']?.toString() ?? 
                        studentData['StudentName']?.toString() ?? 
                        studentID;
          
          studentFaculty = studentData['StudentFaculty']?.toString() ?? 
                           studentData['faculty']?.toString() ?? 
                           'Unknown Faculty';
          
          print("📋 Student found: $studentName, Faculty: $studentFaculty");
        } else {
          print("⚠️ Student document not found for ID: $studentID");
          studentName = studentID;
          studentFaculty = 'Unknown Faculty';
        }
      } catch (e) {
        print("Could not fetch student details: $e");
        studentName = studentID;
        studentFaculty = 'Unknown Faculty';
      }

      // Get module name from CurriculumModule
      String moduleName = '';
      try {
        final moduleSnapshot = await _firestore
            .collection(_modulesCollection)
            .where('ModuleCode', isEqualTo: moduleCode)
            .get();
        if (moduleSnapshot.docs.isNotEmpty) {
          final moduleData = moduleSnapshot.docs.first.data() as Map<String, dynamic>;
          moduleName = moduleData['ModuleName']?.toString() ?? '';
          print("📋 Module found: $moduleCode - $moduleName");
        }
      } catch (e) {
        print("Could not fetch module details: $e");
      }

      // Save to CreditClaim table with ALL fields
      await _firestore.collection(_creditClaimsCollection).add({
        'StudentID': studentID,
        'StudentName': studentName,
        'StudentFaculty': studentFaculty,
        'ModuleCode': moduleCode,
        'ModuleName': moduleName,
        'CreditsClaimed': credits,
        'ClaimDate': FieldValue.serverTimestamp(),
        'Status': 'pending',
        'VerifiedBy': null,
        'VerifiedDate': null,
      });

      print("✅ Credit claim submitted successfully!");
      print("   - Student: $studentName");
      print("   - Faculty: $studentFaculty");
      print("   - Module: $moduleCode - $moduleName");
      return true;
    } catch (e) {
      print("❌ Error submitting credit claim: $e");
      return false;
    }
  }

  /// Get completed modules for credit claim (legacy method)
  Future<List<Map<String, dynamic>>> getCompletedModules(
    String StudentID,
  ) async {
    try {
      print('Fetching completed modules for Student: $StudentID');

      QuerySnapshot snapshot = await _firestore
          .collection(_registeredCollection)
          .where('StudentID', isEqualTo: StudentID)
          .where('Status', isEqualTo: 'completed')
          .get();

      List<Map<String, dynamic>> completedModules = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        DocumentSnapshot moduleDoc = await _firestore
            .collection(_modulesCollection)
            .doc(data['ModuleID'])
            .get();

        if (moduleDoc.exists) {
          var moduleData = moduleDoc.data() as Map<String, dynamic>;

          // Check if already claimed
          QuerySnapshot claimCheck = await _firestore
              .collection(_creditClaimsCollection)
              .where('StudentID', isEqualTo: StudentID)
              .where('ModuleID', isEqualTo: data['ModuleID'])
              .get();

          String claimStatus = claimCheck.docs.isNotEmpty
              ? 'pending'
              : 'not_claimed';

          // Get schedule info
          String classDate = '';
          String startTime = '';
          String endTime = '';

          if (moduleData['scheduleSlots'] != null &&
              moduleData['scheduleSlots'] is List &&
              (moduleData['scheduleSlots'] as List).isNotEmpty) {
            var firstSlot = (moduleData['scheduleSlots'] as List)[0];
            if (firstSlot is Map<String, dynamic>) {
              classDate = firstSlot['date']?.toString() ?? '';
              startTime = firstSlot['startTime']?.toString() ?? '';
              endTime = firstSlot['endTime']?.toString() ?? '';
            }
          } else {
            classDate = moduleData['classDate']?.toString() ?? '';
            startTime = moduleData['startTime']?.toString() ?? '';
            endTime = moduleData['endTime']?.toString() ?? '';
          }

          completedModules.add({
            'id': data['ModuleID'],
            'moduleCode':
                moduleData['ModuleCode']?.toString() ??
                data['ModuleCode']?.toString() ??
                '',
            'moduleName':
                moduleData['ModuleName']?.toString() ??
                data['ModuleName']?.toString() ??
                '',
            'classDate': classDate,
            'startTime': startTime,
            'endTime': endTime,
            'credits': moduleData['credits'] ?? 1,
            'claimStatus': claimStatus,
          });
        }
      }

      print('Found ${completedModules.length} completed modules');
      return completedModules;
    } catch (e) {
      print('Error fetching completed modules: $e');
      return [];
    }
  }

  /// Save credit claim data to Firebase (legacy method)
  Future<void> saveCreditClaimData(
    String StudentID,
    String ModuleID,
    int CreditsClaimed,
  ) async {
    try {
      print('Saving credit claim for Student: $StudentID, Module: $ModuleID');

      // Get student details
      String studentName = '';
      String studentFaculty = '';

      try {
        DocumentSnapshot studentDoc = await _firestore
            .collection('Student')
            .doc(StudentID)
            .get();

        if (studentDoc.exists) {
          var studentData = studentDoc.data() as Map<String, dynamic>;
          studentName =
              studentData['name']?.toString() ??
              studentData['StudentName']?.toString() ??
              '';
          studentFaculty =
              studentData['faculty']?.toString() ??
              studentData['StudentFaculty']?.toString() ??
              '';
        }
      } catch (e) {
        print('Could not fetch student details: $e');
      }

      // Save to CreditClaim collection
      await _firestore.collection(_creditClaimsCollection).add({
        'StudentID': StudentID,
        'ModuleID': ModuleID,
        'CreditsClaimed': CreditsClaimed,
        'ClaimDate': FieldValue.serverTimestamp(),
        'Status': 'pending',
        'StudentName': studentName,
        'StudentFaculty': studentFaculty,
        'VerifiedBy': null,
        'VerifiedDate': null,
      });

      print('Credit claim saved successfully');
    } catch (e) {
      print('Error saving credit claim: $e');
      throw Exception('Failed to save credit claim: $e');
    }
  }

  // ==============================================
  // HELPER METHODS
  // ==============================================

  void returnSubjectList(List<CurriculumModulesModel> subjectList) {}
  void returnSaveConfirmation() {}
  void returnRegisteredSubjects(
    List<CurriculumModulesModel> registeredSubjectsList,
  ) {}
  void returnDropConfirmation() {}
  void returnRecordedModules(
    List<CurriculumModulesModel> recordedModulesList,
  ) {}
}