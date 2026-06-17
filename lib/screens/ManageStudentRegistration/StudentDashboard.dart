import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'StudentOpenRegistrationPage.dart';
import 'MySubjectPage.dart';
import 'LoginPage.dart';

class StudentDashboard extends StatefulWidget {
  final String username;
  final String? studentId;
  final String? studentName;
  final String? matricId;
  final String? email;

  const StudentDashboard({
    super.key, 
    required this.username,
    this.studentId,
    this.studentName,
    this.matricId,
    this.email,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // ✅ Guna data dari widget (dihantar dari LoginPage)
  late String _displayUsername;
  late String _displayStudentId;
  late String _displayStudentName;
  late String _displayMatricId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    // ✅ Guna data yang dihantar dari login
    _displayUsername = widget.username.isNotEmpty ? widget.username : 'STUDENT';
    _displayStudentId = widget.studentId ?? widget.username;
    _displayStudentName = widget.studentName ?? widget.username;
    _displayMatricId = widget.matricId ?? widget.username;
    
    print('✅ StudentDashboard - User: $_displayUsername');
    print('   - Student ID: $_displayStudentId');
    print('   - Student Name: $_displayStudentName');
    print('   - Matric ID: $_displayMatricId');
  }

  // ✅ Handle logout
  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Top Right: Username & Logout (SAMA)
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _displayUsername,  // ✅ Guna username yang login
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF466289),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF1976D2),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF466289),
                        size: 22,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main Application Header Label (SAME)
              const Text(
                'STUDENT ACADEMIC\nMANAGEMENT SYSTEM',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.3,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Large Circular Center Logo (SAME)
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
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
                          size: 75,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ✅ Navigation Buttons (SAME) - Guna data student yang login
              _buildDashboardButton(
                label: 'OPEN REGISTRATION',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentOpenRegistrationPage(
                        studentId: _displayStudentId,      // ✅ Student ID yang login
                        studentName: _displayStudentName,  // ✅ Student Name yang login
                        matricId: _displayMatricId,        // ✅ Matric ID yang login
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildDashboardButton(
                label: 'MY SUBJECTS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MySubjectPage(
                        studentId: _displayStudentId,      // ✅ Student ID yang login
                        studentName: _displayStudentName,  // ✅ Student Name yang login
                        matricId: _displayMatricId,        // ✅ Matric ID yang login
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildDashboardButton(
                label: 'CURRICULUM',
                onPressed: () {
                  // Direct to Classes module view
                },
              ),
              const SizedBox(height: 16),

              _buildDashboardButton(
                label: 'FEE PAYMENT',
                onPressed: () {
                  // Direct to Payments module view
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builder method generating unified full-width option styling block rows (SAME)
  Widget _buildDashboardButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}