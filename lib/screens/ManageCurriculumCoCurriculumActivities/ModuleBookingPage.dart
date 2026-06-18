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
      backgroundColor: const Color(0xFFDCE5F4), // Exact matching background color
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                
                // Top Header - Matric ID Placement
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        matricId,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C274C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down, 
                        size: 18, 
                        color: Color(0xFF2979FF)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Main Title
                const Text(
                  'MODULE BOOKING',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800, // This is Flutter's equivalent for extra bold
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 25),

                // UMPSA Logo (Central Circle)
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/sams_logo.png', // Your asset path
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback container matching UI design theme if asset is missing
                          return Container(
                            color: const Color(0xFF0D3E73),
                            child: const Icon(
                              Icons.school,
                              size: 70,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),

                // Module List Layout
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D3E73)),
                    ),
                  )
                else if (_modules.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No modules available',
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _modules.length,
                    itemBuilder: (context, index) {
                      final module = _modules[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FC), // Clean white-ish tone for capsules
                          borderRadius: BorderRadius.circular(30), // Perfect pill shape
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
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
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            child: Text(
                              '${module.ModuleCode}  ${module.ModuleName.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}