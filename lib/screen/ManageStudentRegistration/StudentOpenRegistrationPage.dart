import 'package:flutter/material.dart';
import 'SubjectRegistrationListPage.dart';
import 'MySubjectPage.dart';

class StudentOpenRegistrationPage extends StatelessWidget {
  const StudentOpenRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE8F5FD,
      ), // Light baby blue background matching design system
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Inline Header Section (Replaces default AppBar layout)
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
                    children: const [
                      Text(
                        'CB23048',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF466289),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Page Title Label
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

              // Central University Badge Circle Image
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
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

              // Menu Selection Block 1: Subject Registration
              _buildLargeSelectionCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubjectRegistrationListPage(),
                    ),
                  );
                },
                iconPathOrWidget: const Icon(
                  Icons
                      .assignment_ind_outlined, // Custom academic assignment asset simulation
                  size: 50,
                  color: Color(0xFF6C6C6C),
                ),
                titleText: 'SUBJECT\nREGISTRATION',
                textColor: const Color(
                  0xFF0D47A1,
                ), // Exact dark slate blue font shade
              ),
              const SizedBox(height: 24),

              // Menu Selection Block 2: My Subjects
              _buildLargeSelectionCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MySubjectPage()),
                  );
                },
                iconPathOrWidget: const Icon(
                  Icons.groups_rounded, // Styled group asset match
                  size: 50,
                  color: Colors.black,
                ),
                titleText: 'MY SUBJECTS',
                textColor: const Color(
                  0xFF800000,
                ), // Precise dark deep wine red tone
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Generates card layouts corresponding precisely to the layout block specs
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
            color: Color.fromRGBO(0, 0, 0, 0.08),
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
                // Left hand illustrative vector container
                SizedBox(width: 60, child: iconPathOrWidget),
                const SizedBox(width: 16),

                // Right aligned label formatting
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
