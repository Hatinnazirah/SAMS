import 'package:flutter/material.dart';
import 'screens/ManageCurriculumCoCurriculumActivities/GradeActivitiesPage.dart';
import 'screens/ManageCurriculumCoCurriculumActivities/VerifyCreditPage.dart';

class PusatAdabDashboard extends StatelessWidget {
  final String staffId = "PUSAT ADAB";

  const PusatAdabDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4), // Light blue canvas background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Custom Header bar (Back arrow and dropdown info status bar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          staffId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Main Section Screen Header
                const Text(
                  'CURRICULUM',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 25),

                // UMPSA Logo Central Graphic Element
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/sams_logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 45),

                // GRADE ACTIVITY Action Card
                _buildMenuButton(
                  context: context,
                  title: 'GRADE ACTIVITY',
                  iconPath: 'assets/icons/PusatAdabIcon1.png',
                  textColor: const Color(0xFF144B83), // Deep blue color text
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GradeActivitiesPage()),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // VERIFY CREDIT Action Card
                _buildMenuButton(
                  context: context,
                  title: 'VERIFY CREDIT',
                  iconPath: 'assets/icons/PusatAdabIcon2.png',
                  textColor: const Color(0xFF800C0C), // Deep maroon/red color text
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyCreditPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Refactored helper widget matching the clean UI spacing metrics of StudentCurriculumPage
  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required String iconPath,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    List<String> words = title.split(" ");
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5), // Soft floating drop-shadow profile
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24), // Matches internal layout padding
            child: Row(
              children: [
                // Icon sizing completely unified with StudentCurriculumPage configuration
                Image.asset(
                  iconPath,
                  width: 45,
                  height: 45,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 45, color: Colors.grey[400]);
                  },
                ),
                const SizedBox(width: 24), // Sizing width matching the benchmark model
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Left aligned framework matching target style
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        words[0],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (words.length > 1)
                        Text(
                          words[1],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
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