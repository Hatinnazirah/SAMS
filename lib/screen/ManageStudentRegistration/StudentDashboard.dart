import 'package:flutter/material.dart';
import 'StudentOpenRegistrationPage.dart';
import 'MySubjectPage.dart';
import 'LoginPage.dart';

class StudentDashboard extends StatefulWidget {
  final String username;

  const StudentDashboard({super.key, required this.username});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late final String _displayUsername;

  @override
  void initState() {
    super.initState();
    _displayUsername = widget.username.isNotEmpty ? widget.username : 'STUDENT';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE8F5FD,
      ), // Light baby blue background matching UI mockups
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Right Layout Container: Role Selector & Logout Action
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username display segment
                    Text(
                      _displayUsername,
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
                    const SizedBox(
                      width: 12,
                    ), // Visual spacer spacing out logout button
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF466289),
                        size: 22,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main Application Header Label
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

              // Large Circular Center Logo
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.12),
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
                      // Visual fallback if asset bundle hasn't registered item yet
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

              // Vertically Stacked Navigation Menu Buttons
              _buildDashboardButton(
                label: 'OPEN REGISTRATION',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StudentOpenRegistrationPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildDashboardButton(
                label: 'CURRICULUM',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MySubjectPage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildDashboardButton(
                label: 'CLASSES',
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

  // Builder method generating unified full-width option styling block rows
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
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF1976D2,
            ), // Royal Blue fill background
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Smooth round corners
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
