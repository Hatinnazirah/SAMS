import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';

class ViewParticipantsPage extends StatefulWidget {
  const ViewParticipantsPage({super.key});

  @override
  State<ViewParticipantsPage> createState() => _ViewParticipantsPageState();
}

class _ViewParticipantsPageState extends State<ViewParticipantsPage> {
  final RegistrationController _controller = RegistrationController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<SubjectModel> _subjects = [];
  List<RegistrationModel> _participants = [];
  bool _isLoadingSubjects = true;
  bool _isLoadingParticipants = false;
  
  // Cache for student names
  final Map<String, String> _studentNameCache = {};
  final Map<String, String> _studentMatricCache = {};

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // ✅ Load subjects from Firebase
  Future<void> _loadSubjects() async {
    setState(() => _isLoadingSubjects = true);
    _subjects = await _controller.getAvailableSubjects();
    setState(() => _isLoadingSubjects = false);
  }

  // ✅ Load participants from Firebase with student names
  Future<void> _loadParticipants(String subjectId) async {
    setState(() => _isLoadingParticipants = true);
    _participants = await _controller.getSubjectParticipants(subjectId);
    
    // ✅ Fetch student names for each participant from Firebase
    for (var participant in _participants) {
      await _fetchStudentName(participant.studentId);
    }
    
    setState(() => _isLoadingParticipants = false);
  }

  // ✅ Fetch student name from Firebase Student collection
  Future<void> _fetchStudentName(String studentId) async {
    if (_studentNameCache.containsKey(studentId)) return;
    
    try {
      // Try Student collection first
      QuerySnapshot snapshot = await _firestore
          .collection('Student')
          .where('StudentID', isEqualTo: studentId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        // Try by MatricId
        snapshot = await _firestore
            .collection('Student')
            .where('MatricId', isEqualTo: studentId)
            .limit(1)
            .get();
      }
      
      if (snapshot.docs.isEmpty) {
        // Try User collection
        snapshot = await _firestore
            .collection('User')
            .where('Username', isEqualTo: studentId)
            .limit(1)
            .get();
      }
      
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        final name = data['StudentName'] ?? 
                     data['FullName'] ?? 
                     data['Name'] ?? 
                     studentId;
        final matric = data['MatricId'] ?? 
                      data['Username'] ?? 
                      studentId;
        _studentNameCache[studentId] = name;
        _studentMatricCache[studentId] = matric;
        print('✅ Found student: $name ($studentId)');
      } else {
        _studentNameCache[studentId] = studentId;
        _studentMatricCache[studentId] = studentId;
        print('⚠️ Student not found: $studentId');
      }
    } catch (e) {
      print('❌ Error fetching student: $e');
      _studentNameCache[studentId] = studentId;
      _studentMatricCache[studentId] = studentId;
    }
  }

  // ✅ Get student name from cache
  String _getStudentName(String studentId) {
    return _studentNameCache[studentId] ?? studentId;
  }

  // ✅ Get student matric from cache
  String _getStudentMatric(String studentId) {
    return _studentMatricCache[studentId] ?? studentId;
  }

  // ✅ Show participants modal
  void _showParticipantsModal(
    BuildContext context,
    SubjectModel subject,
  ) async {
    // Load participants
    await _loadParticipants(subject.subjectId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext colContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Color(0xFFDCE6F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  // Modal Pill Decorator Handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(110, 126, 149, 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Subject Code Header
                  Text(
                    subject.subjectCode,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subject.subjectName.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF556477),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Enrolled counter
                  Text(
                    '${_participants.length} Active Participants',
                    style: const TextStyle(
                      color: Color(0xFF1570D5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 24,
                    color: Color(0xFFC9D6EA),
                    thickness: 1.2,
                  ),

                  // ✅ Participant List
                  Expanded(
                    child: _isLoadingParticipants
                        ? const Center(child: CircularProgressIndicator())
                        : _participants.isEmpty
                        ? const Center(
                            child: Text(
                              'No students registered yet',
                              style: TextStyle(
                                color: Color(0xFF6E7E95),
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _participants.length,
                            itemBuilder: (context, idx) {
                              final p = _participants[idx];
                              final studentName = _getStudentName(p.studentId);
                              final studentMatric = _getStudentMatric(p.studentId);
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFC9D6EA),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      studentName.isNotEmpty
                                          ? studentName[0].toUpperCase()
                                          : 'S',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    studentName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        'ID: $studentMatric',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF556477),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Approved',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color pageBackgroundColor = Color(0xFFDCE6F5);
    const Color darkText = Colors.black;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navigation Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Title Header
              const Text(
                'VIEW PARTICIPANTS',
                style: TextStyle(
                  color: darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // ✅ Logo - SAMS LOGO (same as other pages)
              Container(
                width: 100,
                height: 100,
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

              // ✅ Subject List
              Expanded(
                child: _isLoadingSubjects
                    ? const Center(child: CircularProgressIndicator())
                    : _subjects.isEmpty
                    ? const Center(
                        child: Text(
                          'No courses available',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _subjects.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          final subject = _subjects[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GestureDetector(
                              onTap: () =>
                                  _showParticipantsModal(context, subject),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(0, 0, 0, 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${subject.subjectCode}  ${subject.subjectName.toUpperCase()}',
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF556477),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
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