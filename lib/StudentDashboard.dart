import 'package:flutter/material.dart';
import 'package:sams_app/screens/ManageCurriculumCoCurriculumActivities/StudentCurriculumPage.dart';
import 'package:sams_app/screens/ManageCurriculumCoCurriculumActivities/MySubjectsPage.dart';
import 'package:sams_app/screens/ManageCurriculumCoCurriculumActivities/ActivitiesPage.dart';
import 'package:sams_app/screens/ManageCurriculumCoCurriculumActivities/CreditClaimPage.dart';
import 'package:sams_app/screens/ManageCurriculumCoCurriculumActivities/ModuleBookingPage.dart';


class StudentDashboard extends StatelessWidget {
  final String matricId = "CB23048";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1E9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(matricId),
                      const Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('CURRICULUM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                ClipOval(
                  child: Image.asset(
                    'assets/icons/sams_logo.png',  // ← Add your logo PNG here
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 35),
                _buildMenuButton(
                  title: 'MODULE BOOKING',
                  textColor: const Color(0xFF0F4C81),
                  imagePath: 'assets/icons/ModuleBookingIcon.png',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCurriculumPage()));
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  title: 'MY SUBJECTS',
                  textColor: const Color(0xFF800000),
                  imagePath: 'assets/icons/MySubjectsIcon.png',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MySubjectsPage()));
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  title: 'ACTIVITIES',
                  textColor: const Color(0xFFFF9200),
                  imagePath: 'assets/icons/ActivitiesIcon.png',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesPage()));
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  title: 'CREDIT CLAIM',
                  textColor: const Color(0xFF00A800),
                  imagePath: 'assets/icons/CreditClaimIcon.png',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreditClaimPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String title,
    required Color textColor,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 45,
              height: 45,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}