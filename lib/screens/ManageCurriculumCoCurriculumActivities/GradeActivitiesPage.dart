import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/PusatAdabController.dart';
import 'GradeActivitiesListPage.dart';

class GradeActivitiesPage extends StatefulWidget {
  @override
  _GradeActivitiesPageState createState() => _GradeActivitiesPageState();
}

class _GradeActivitiesPageState extends State<GradeActivitiesPage> {
  final PusatAdabController _controller = PusatAdabController();
  List<Map<String, dynamic>> _modulesWithSubmissions = [];
  bool _isLoading = true;
  final String staffId = "PUSAT ADAB";

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    _modulesWithSubmissions = await _controller.getSubmittedActivitiesList();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom Top Header Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          staffId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Unified Main Header Layout
              const Text(
                'GRADE ACTIVITY',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 25),
              
              // Standardized Central Round Logo Graphic
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
              const SizedBox(height: 35),

              // Content Items Section
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_modulesWithSubmissions.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      'No pending submissions to grade',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _modulesWithSubmissions.map((module) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F5FA), // Subtle grey-blue matching visual style
                          borderRadius: BorderRadius.circular(30), // Extended rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 4), // Soft shadow profile
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GradeActivitiesListPage(
                                    moduleId: module['moduleId'],
                                    moduleCode: module['moduleCode'],
                                    moduleName: module['moduleName'],
                                    submissions: module['submissions'] ?? [],
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center text inside the row
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${module['moduleCode']}  ${module['moduleName'].toUpperCase()}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500, // Medium weight matching image reference
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}