import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SubjectRegistrationListPage.dart';
import 'MySubjectPage.dart';

class StudentOpenRegistrationPage extends StatefulWidget {
  final String? studentId;
  final String? studentName;
  final String? matricId;

  const StudentOpenRegistrationPage({
    super.key,
    this.studentId,
    this.studentName,
    this.matricId,
  });

  @override
  State<StudentOpenRegistrationPage> createState() =>
      _StudentOpenRegistrationPageState();
}

class _StudentOpenRegistrationPageState
    extends State<StudentOpenRegistrationPage> {
  late String _studentId;
  late String _studentName;
  late String _matricId;
  bool _isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeStudentData();
  }

  void _initializeStudentData() {
    // Guna data dari widget (dihantar dari StudentDashboard)
    _studentId = widget.studentId ?? 'CB23048';
    _studentName = widget.studentName ?? 'Student';
    _matricId = widget.matricId ?? 'CB23048';

    // Kalau takde data, ambil dari Firebase
    if (widget.studentId == null || widget.studentName == null) {
      _fetchStudentDataFromFirebase();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchStudentDataFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('User')
          .where('Username', isEqualTo: _studentId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        snapshot = await _firestore
            .collection('Student')
            .where('StudentID', isEqualTo: _studentId)
            .limit(1)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _studentName = data['FullName'] ?? data['StudentName'] ?? _studentId;
          _studentId = data['StudentID'] ?? data['Username'] ?? _studentId;
          _matricId = data['MatricId'] ?? data['Username'] ?? _studentId;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error fetching student data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8F5FD),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF1976D2)),
              SizedBox(height: 16),
              Text('Loading...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Header - SAMA macam asal (tapi guna nama student yang login)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 26,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _studentName,  // ✅ Guna nama student yang login
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF466289),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ✅ Page Title - SAMA
              const Text(
                'OPEN REGISTRATION',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Logo - SAMA
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/SAMS LOGO.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E3A60),
                        child: const Icon(
                          Icons.school,
                          size: 65,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Menu Selection Block 1 - SAMA
              _buildLargeSelectionCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectRegistrationListPage(
                        studentId: _studentId,      // ✅ Pass studentId
                        studentName: _studentName,  // ✅ Pass studentName
                        matricId: _matricId,        // ✅ Pass matricId
                      ),
                    ),
                  );
                },
                iconPathOrWidget: const Icon(
                  Icons.assignment_ind_outlined,
                  size: 50,
                  color: Color(0xFF6C6C6C),
                ),
                titleText: 'SUBJECT\nREGISTRATION',
                textColor: const Color(0xFF0D47A1),
              ),
              const SizedBox(height: 24),

              // ✅ Menu Selection Block 2 - SAMA
              _buildLargeSelectionCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MySubjectPage(
                        studentId: _studentId,      // ✅ Pass studentId
                        studentName: _studentName,  // ✅ Pass studentName
                        matricId: _matricId,        // ✅ Pass matricId
                      ),
                    ),
                  );
                },
                iconPathOrWidget: const Icon(
                  Icons.groups_rounded,
                  size: 50,
                  color: Colors.black,
                ),
                titleText: 'MY SUBJECTS',
                textColor: const Color(0xFF800000),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ SAME card layout
  Widget _buildLargeSelectionCard({
    required VoidCallback onTap,
    required Widget iconPathOrWidget,
    required String titleText,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                SizedBox(width: 60, child: iconPathOrWidget),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.1,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}