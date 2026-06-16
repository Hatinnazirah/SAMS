import 'package:flutter/material.dart';

class FacultyRegistrarDashboard extends StatefulWidget {
  const FacultyRegistrarDashboard({super.key});

  @override
  State<FacultyRegistrarDashboard> createState() =>
      _FacultyRegistrarDashboardState();
}

class _FacultyRegistrarDashboardState extends State<FacultyRegistrarDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Standardizing status bar color style matching the light background
      backgroundColor: const Color(0xffe6f4fe),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar: User Dropdown Alignment
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ALI BIN ABU',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // System Title Text
              Text(
                'STUDENT ACADEMIC\nMANAGEMENT SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black.withOpacity(0.85),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),

              // Circular Logo Container
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(
                    0xff0d335d,
                  ), // Dark blue background color matching the logo
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/SAMS LOGO.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xff0d335d),
                        child: const Icon(
                          Icons.school,
                          size: 60,
                          color: Colors.lightBlueAccent,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Open Registration Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle your registration logic action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xff1573db,
                    ), // Vibrant blue matching the design
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ), // Rounded pill shape corners
                    ),
                  ),
                  child: const Text(
                    'OPEN REGISTRATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
