import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';
import 'SubjectApprovalPage.dart';

class ManageRegistrationPage extends StatefulWidget {
  const ManageRegistrationPage({super.key});

  @override
  State<ManageRegistrationPage> createState() => _ManageRegistrationPageState();
}

class _ManageRegistrationPageState extends State<ManageRegistrationPage> {
  final RegistrationController _controller = RegistrationController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<RegistrationModel> _pendingRegistrations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  
  // Cache for subject data
  final Map<String, Map<String, dynamic>> _subjectCache = {};
  
  // Cache for student data
  final Map<String, Map<String, dynamic>> _studentCache = {};

  @override
  void initState() {
    super.initState();
    _loadPendingRegistrations();
  }

  // ✅ Load pending registrations from Firebase with student data
  Future<void> _loadPendingRegistrations() async {
    setState(() => _isLoading = true);
    
    try {
      // Get all pending registrations from Firebase
      final QuerySnapshot registrationSnapshot = await _firestore
          .collection('Registration')
          .where('Status', isEqualTo: 'pending')
          .get();

      final List<RegistrationModel> registrations = [];

      for (var doc in registrationSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Get subject data from cache or Firebase
        final String subjectId = data['SubjectId'] ?? '';
        Map<String, dynamic> subjectData = {};
        
        if (_subjectCache.containsKey(subjectId)) {
          subjectData = _subjectCache[subjectId]!;
        } else {
          final subjectDoc = await _firestore
              .collection('Subject')
              .where('SubjectID', isEqualTo: subjectId)
              .limit(1)
              .get();
              
          if (subjectDoc.docs.isNotEmpty) {
            subjectData = subjectDoc.docs.first.data() as Map<String, dynamic>;
            _subjectCache[subjectId] = subjectData;
          }
        }
        
        // ✅ Get student data from Firebase (Student collection)
        final String studentId = data['StudentId'] ?? '';
        Map<String, dynamic> studentData = {};
        String studentName = data['StudentName'] ?? '';
        String studentMatricId = data['MatricId'] ?? '';
        
        if (_studentCache.containsKey(studentId)) {
          studentData = _studentCache[studentId]!;
        } else {
          // ✅ Search Student collection first
          QuerySnapshot studentSnapshot = await _firestore
              .collection('Student')
              .where('StudentID', isEqualTo: studentId)
              .limit(1)
              .get();
          
          if (studentSnapshot.docs.isEmpty) {
            // Try by MatricId
            studentSnapshot = await _firestore
                .collection('Student')
                .where('MatricId', isEqualTo: studentId)
                .limit(1)
                .get();
          }
          
          if (studentSnapshot.docs.isEmpty) {
            // Try User collection
            studentSnapshot = await _firestore
                .collection('User')
                .where('Username', isEqualTo: studentId)
                .limit(1)
                .get();
          }
          
          if (studentSnapshot.docs.isNotEmpty) {
            studentData = studentSnapshot.docs.first.data() as Map<String, dynamic>;
            _studentCache[studentId] = studentData;
          }
        }
        
        // ✅ Get student name from Firebase or registration
        if (studentData.isNotEmpty) {
          studentName = studentData['StudentName'] ?? 
                       studentData['FullName'] ?? 
                       studentData['Name'] ?? 
                       studentId;
          studentMatricId = studentData['MatricId'] ?? 
                           studentData['Username'] ?? 
                           studentId;
        }
        
        final registration = RegistrationModel(
          registrationId: doc.id,
          studentId: studentId,
          subjectId: subjectId,
          studentName: studentName.isNotEmpty ? studentName : 'Student ${studentId.substring(0, 4)}',
          matricId: studentMatricId.isNotEmpty ? studentMatricId : studentId,
          subjectCode: subjectData['SubjectCode'] ?? data['SubjectCode'] ?? '',
          subjectName: subjectData['SubjectName'] ?? data['SubjectName'] ?? '',
          creditHours: _toInt(data['CreditHours']) ?? _toInt(subjectData['CreditHours']),
          status: _stringToStatus(data['Status'] ?? 'pending'),
          registrationDate: (data['RegistrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          rejectionReason: data['RejectionReason'],
          approvedDate: (data['ApprovedDate'] as Timestamp?)?.toDate(),
          rejectedDate: (data['RejectedDate'] as Timestamp?)?.toDate(),
          lectureSection: data['LectureSection'] ?? 'N/A',
          labSection: data['LabSection'] ?? 'N/A',
        );
        
        registrations.add(registration);
      }

      setState(() {
        _pendingRegistrations = registrations;
        _isLoading = false;
      });
      
      print('✅ Loaded ${registrations.length} pending registrations from Firebase');
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌ Error loading pending registrations: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading registrations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============ HELPER METHODS ============

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  RegistrationStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return RegistrationStatus.approve;
      case 'rejected':
        return RegistrationStatus.reject;
      default:
        return RegistrationStatus.pending;
    }
  }

  // ✅ Group registrations by subject
  List<Map<String, dynamic>> _groupRegistrationsBySubject() {
    final Map<String, List<RegistrationModel>> grouped = {};
    
    for (var reg in _pendingRegistrations) {
      final key = reg.subjectId;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(reg);
    }
    
    final List<Map<String, dynamic>> result = [];
    grouped.forEach((subjectId, registrations) {
      if (registrations.isNotEmpty) {
        result.add({
          'subjectId': subjectId,
          'subjectCode': registrations.first.subjectCode,
          'subjectName': registrations.first.subjectName,
          'registrations': registrations,
          'count': registrations.length,
        });
      }
    });
    
    // Sort by subject code
    result.sort((a, b) => a['subjectCode'].compareTo(b['subjectCode']));
    return result;
  }

  // Refresh data
  Future<void> _refreshData() async {
    _subjectCache.clear();
    _studentCache.clear();
    await _loadPendingRegistrations();
  }

  @override
  Widget build(BuildContext context) {
    const Color pageBackgroundColor = Color(0xFFDEE6F5); 
    const Color inputFieldFillColor = Color(0xFFC7D3E5);
    const Color darkText = Colors.black;

    // ✅ Get grouped registrations
    final groupedSubjects = _groupRegistrationsBySubject();
    
    // ✅ Filter groups by search query
    final filteredGroups = groupedSubjects.where((group) {
      final query = _searchQuery.toLowerCase();
      final code = group['subjectCode'].toLowerCase();
      final name = group['subjectName'].toLowerCase();
      // Also search student names in the group
      final studentNames = (group['registrations'] as List<RegistrationModel>)
          .map((r) => r.studentName.toLowerCase())
          .join(' ');
      return code.contains(query) || name.contains(query) || studentNames.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: darkText, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Title Header Text
              const Text(
                'MANAGE REGISTRATION',
                style: TextStyle(
                  color: darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Logo
              Container(
                width: 105,
                height: 105,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/SAMS LOGO.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF0F3460),
                        child: const Icon(
                          Icons.school,
                          size: 34,
                          color: Color(0xFF76C4EE),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: inputFieldFillColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF5A6B82), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: const TextStyle(color: Color(0xFF334155), fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'code, subject name, or student',
                            hintStyle: TextStyle(color: Color(0xFF5A6B82), fontSize: 16),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Grouped Registration List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredGroups.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.inbox,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No pending registrations',
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  child: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredGroups.length,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemBuilder: (context, index) {
                              final group = filteredGroups[index];
                              final List<RegistrationModel> registrations = group['registrations'];
                              final count = group['count'];
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ✅ Subject Header with Count Badge
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${group['subjectCode']}  ${group['subjectName']}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '$count student${count > 1 ? 's' : ''} waiting for approval',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ✅ Count Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF30000).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '$count',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFF30000),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // ✅ Student List
                                    ...registrations.map((registration) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SubjectApprovalPage(
                                                registration: registration,
                                              ),
                                            ),
                                          ).then((_) => _loadPendingRegistrations());
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          margin: const EdgeInsets.symmetric(horizontal: 14),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              // Student Info
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    // ✅ Student initial avatar
                                                    CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor: Colors.blue.shade100,
                                                      child: Text(
                                                        registration.studentName.isNotEmpty
                                                            ? registration.studentName[0].toUpperCase()
                                                            : 'S',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue.shade800,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            registration.studentName.isNotEmpty 
                                                                ? registration.studentName 
                                                                : 'Student ${registration.studentId}',
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                          Text(
                                                            'ID: ${registration.studentId}',
                                                            style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              
                                              // ✅ Arrow indicator
                                              const Icon(
                                                Icons.chevron_right,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}