import 'package:flutter/material.dart';
import 'FeeStatusPage.dart';

class StudentFeeDashboard extends StatelessWidget {

  final String studentID;

  const StudentFeeDashboard({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      studentID,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "STUDENT ACADEMIC\nMANAGEMENT SYSTEM",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ClipOval(
                child: Image.asset(
                  'assets/icons/sams_logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeeStatusPage(
                          studentID: studentID,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "FEE PAYMENT",
                    style: TextStyle(
                      fontSize: 18,
                    ),
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