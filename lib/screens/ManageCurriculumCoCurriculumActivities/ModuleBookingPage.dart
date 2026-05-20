import 'package:flutter/material.dart';
import 'package:sams_app/Domain/ManageCurriculumCoCurriculumActivities/CurriculumModulesModel.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/StudentController.dart';
import 'SubjectListPage.dart';

class ModuleBookingPage extends StatefulWidget {
  @override
  _ModuleBookingPageState createState() => _ModuleBookingPageState();
}

class _ModuleBookingPageState extends State<ModuleBookingPage> {
  final StudentController _controller = StudentController();
  List<CurriculumModulesModel> _modules = [];
  bool _isLoading = true;
  final String matricId = "CB23048";

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    _modules = await _controller.getAvailableSubjects();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE1E9F6), // Matches background of Picture 2
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Custom Top Header Action Bar (Replaces default Teal AppBar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          matricId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                      ],
                    ),
                  ],
                ),
              ),

              // Title Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'MODULE BOOKING',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Circular Logo Container
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0D3E73), // Deep Blue tint matching background of logo
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/sams_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Content Items Section
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_modules.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      'No modules available',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _modules.map((module) {
                      return Container(
                        width: double.infinity, // Ensures the pill stretches symmetrically across width
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F5FA), // Crisp light background for buttons
                          borderRadius: BorderRadius.circular(30), // True Pill Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectListPage(module: module),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                            child: Text(
                              '${module.ModuleCode}   ${module.ModuleName.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                letterSpacing: 0.2,
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