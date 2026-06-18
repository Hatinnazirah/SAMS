import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';
import 'package:sams_app/screens/ManageStudentRegistration/RejectionReasonForm.dart';

class SubjectApprovalPage extends StatefulWidget {
  final RegistrationModel registration;

  const SubjectApprovalPage({super.key, required this.registration});

  @override
  State<SubjectApprovalPage> createState() => _SubjectApprovalPageState();
}

class _SubjectApprovalPageState extends State<SubjectApprovalPage> {
  final RegistrationController _controller = RegistrationController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  
  // Additional data from Firebase
  Map<String, dynamic>? _subjectData;
  Map<String, dynamic>? _studentData;
  bool _isLoadingData = true;

  // ✅ Student data from Firebase
  String _studentName = '';
  String _studentEmail = '';
  String _studentPhone = '';
  String _studentProgram = '';
  String _studentMatricId = '';

  @override
  void initState() {
    super.initState();
    _loadAdditionalData();
  }

  // ✅ Load additional data from Firebase
  Future<void> _loadAdditionalData() async {
    setState(() => _isLoadingData = true);
    
    try {
      // Load subject data from Firebase
      final subjectSnapshot = await _firestore
          .collection('Subject')
          .where('SubjectID', isEqualTo: widget.registration.subjectId)
          .limit(1)
          .get();
          
      if (subjectSnapshot.docs.isNotEmpty) {
        _subjectData = subjectSnapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // ✅ Search for student - TRY STUDENT COLLECTION FIRST
      _studentData = await _findStudentData(widget.registration.studentId);
          
      if (_studentData != null) {
        // ✅ Extract student data with null safety
        _studentName = _studentData!['FullName'] ?? 
                       _studentData!['StudentName'] ?? 
                       _studentData!['Name'] ??
                       widget.registration.studentName ?? 
                       'Unknown Student';
                       
        _studentEmail = _studentData!['Email'] ?? _studentData!['email'] ?? 'N/A';
        _studentPhone = _studentData!['PhoneNumber'] ?? _studentData!['Phone'] ?? _studentData!['phone'] ?? 'N/A';
        
        // ✅ GET StudentProgram FROM STUDENT COLLECTION
        _studentProgram = _studentData!['StudentProgram'] ?? 
                         _studentData!['Program'] ?? 
                         _studentData!['program'] ?? 
                         _studentData!['studentProgram'] ?? 
                         'N/A';
                         
        _studentMatricId = _studentData!['MatricId'] ?? 
                          _studentData!['Username'] ?? 
                          _studentData!['studentId'] ?? 
                          widget.registration.studentId;
                         
        print('✅ Student data loaded:');
        print('   - Name: $_studentName');
        print('   - Student ID: ${widget.registration.studentId}');
        print('   - Program: $_studentProgram');
        print('   - Email: $_studentEmail');
        print('   - Phone: $_studentPhone');
      } else {
        // ✅ Fallback: Use data from registration if Firebase not found
        _studentName = widget.registration.studentName ?? 'Unknown Student';
        _studentEmail = 'N/A';
        _studentPhone = 'N/A';
        _studentProgram = 'N/A';
        _studentMatricId = widget.registration.studentId;
        print('⚠️ Student not found in Firebase, using registration data');
      }
      
    } catch (e) {
      print('❌ Error loading additional data: $e');
      // ✅ Fallback to registration data
      _studentName = widget.registration.studentName ?? 'Unknown Student';
      _studentEmail = 'N/A';
      _studentPhone = 'N/A';
      _studentProgram = 'N/A';
      _studentMatricId = widget.registration.studentId;
    }
    
    setState(() => _isLoadingData = false);
  }

  // ✅ Helper to find student data - SEARCH STUDENT COLLECTION FIRST
  Future<Map<String, dynamic>?> _findStudentData(String studentId) async {
    try {
      print('🔍 Searching for student: $studentId');
      
      // 1️⃣ TRY Student collection by StudentID FIRST (MOST IMPORTANT)
      QuerySnapshot snapshot = await _firestore
          .collection('Student')
          .where('StudentID', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in Student collection by StudentID');
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        print('   - StudentProgram: ${data['StudentProgram']}');
        return data;
      }
      
      // 2️⃣ Try Student collection by MatricId
      snapshot = await _firestore
          .collection('Student')
          .where('MatricId', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in Student collection by MatricId');
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        print('   - StudentProgram: ${data['StudentProgram']}');
        return data;
      }
      
      // 3️⃣ Try User collection by Username
      snapshot = await _firestore
          .collection('User')
          .where('Username', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in User collection by Username');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // 4️⃣ Try User collection by StudentID
      snapshot = await _firestore
          .collection('User')
          .where('StudentID', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in User collection by StudentID');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // 5️⃣ Try Student collection by Name
      snapshot = await _firestore
          .collection('Student')
          .where('StudentName', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in Student collection by StudentName');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      print('⚠️ Student not found in any collection: $studentId');
      return null;
    } catch (e) {
      print('❌ Error finding student: $e');
      return null;
    }
  }

  // ✅ Approve registration - Update Firebase
  Future<void> _approveRegistration() async {
    setState(() => _isLoading = true);

    try {
      final result = await _controller.updateRegistrationStatus(
        widget.registration.registrationId,
        RegistrationStatus.approve,
        null,
      );

      if (result == 'success') {
        await _updateSubjectCurrentEnrolled(widget.registration.subjectId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration approved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  // ✅ Update CurrentEnrolled in Subject collection
  Future<void> _updateSubjectCurrentEnrolled(String subjectId) async {
    try {
      final subjectSnapshot = await _firestore
          .collection('Subject')
          .where('SubjectID', isEqualTo: subjectId)
          .limit(1)
          .get();
          
      if (subjectSnapshot.docs.isNotEmpty) {
        final subjectRef = subjectSnapshot.docs.first.reference;
        await subjectRef.update({
          'CurrentEnrolled': FieldValue.increment(1),
        });
        print('✅ Updated CurrentEnrolled for subject: $subjectId');
      }
    } catch (e) {
      print('❌ Error updating CurrentEnrolled: $e');
    }
  }

  // ✅ Reject registration
  void _rejectRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RejectionReasonForm(
          registration: widget.registration,
        ),
      ),
    ).then((_) => Navigator.pop(context, true));
  }

  // Helper to safely get value
  String _getValue(dynamic value) {
    if (value == null) return 'N/A';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Registration Request'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: _isLoading || _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Student Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Student Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const Divider(),
                        _buildInfoRow('Name', _studentName.isNotEmpty ? _studentName : 'Unknown Student'),
                        _buildInfoRow('Student ID', widget.registration.studentId),
                        _buildInfoRow('Matric ID', _studentMatricId),
                        _buildInfoRow('Email', _studentEmail),
                        _buildInfoRow('Phone', _studentPhone),
                        _buildInfoRow('Program', _studentProgram), // ✅ Should show "BCS"
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Subject Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Subject Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Divider(),
                        _buildInfoRow('Subject Code', widget.registration.subjectCode),
                        _buildInfoRow('Subject Name', widget.registration.subjectName),
                        _buildInfoRow('Credit Hours', '${widget.registration.creditHours} hours'),
                        _buildInfoRow('Lecture Section', widget.registration.lectureSection ?? 'N/A'),
                        _buildInfoRow('Lab Section', widget.registration.labSection ?? 'N/A'),
                        if (_subjectData != null) ...[
                          _buildInfoRow('Lecturer', _getValue(_subjectData!['LecturerName'])),
                          _buildInfoRow('Venue', _getValue(_subjectData!['Venue'])),
                          _buildInfoRow('Schedule', 
                            '${_getValue(_subjectData!['ScheduleDay'])} '
                            '${_getValue(_subjectData!['ScheduleStartTime'])} - '
                            '${_getValue(_subjectData!['ScheduleEndTime'])}'
                          ),
                          _buildInfoRow('Capacity', 
                            '${_getValue(_subjectData!['CurrentEnrolled'])} / '
                            '${_getValue(_subjectData!['MaxCapacity'])}'
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Registration Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registration Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const Divider(),
                        _buildInfoRow('Registration Date', 
                          '${widget.registration.registrationDate.day}/${widget.registration.registrationDate.month}/${widget.registration.registrationDate.year}'
                        ),
                        _buildInfoRow('Status', 
                          widget.registration.getStatusDisplay(),
                          valueColor: widget.registration.getStatusBadgeColor(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ✅ Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _rejectRegistration,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _approveRegistration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14, 
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}