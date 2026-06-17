import 'package:flutter/material.dart';
import 'ManageRegistrationPage.dart';
import 'ViewParticipantsPage.dart';

class FacultyOpenRegistrationPage extends StatelessWidget {
  final String? username;
  final String? fullName;
  final String? email;

  const FacultyOpenRegistrationPage({
    super.key,
    this.username,
    this.fullName,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    // Exact colors extracted from your updated UI image
    const Color pageBackgroundColor = Color(0xFFDCE6F5);
    const Color darkBlueText = Color(0xFF000000);
    const Color manageRegTextColor = Color(0xFF0B467F);
    const Color viewPartTextColor = Color(0xFF700A0A);

    // ✅ Use provided user data or fallback
    final String displayName = fullName ?? username ?? 'Faculty Registrar';

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Custom Header Navigation Row (with user name)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  DropdownButton<String>(
                    value: displayName,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1375D6), size: 20),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: displayName,
                        child: Text(displayName),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Page Title
              const Text(
                'OPEN REGISTRATION',
                style: TextStyle(
                  color: darkBlueText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // UMPSA Logo Circle Branding
              Center(
                child: Container(
                  width: 175,
                  height: 175,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A2E5C),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/SAMS LOGO.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF0A2E5C),
                          child: const Icon(
                            Icons.school_outlined,
                            size: 55,
                            color: Color(0xFF7CD4FD),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 1. MANAGE REGISTRATION CARD SELECTION
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageRegistrationPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'MANAGE',
                              style: TextStyle(
                                color: manageRegTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'REGISTRATION',
                              style: TextStyle(
                                color: manageRegTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. VIEW PARTICIPANTS CARD SELECTION
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ViewParticipantsPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 48,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'VIEW',
                              style: TextStyle(
                                color: viewPartTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'PARTICIPANTS',
                              style: TextStyle(
                                color: viewPartTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}