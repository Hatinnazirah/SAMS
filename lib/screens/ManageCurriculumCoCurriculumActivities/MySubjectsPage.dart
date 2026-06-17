import 'package:flutter/material.dart';
import 'package:sams_app/Domain/ManageCurriculumCoCurriculumActivities/CurriculumModulesModel.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/StudentController.dart';

class MySubjectsPage extends StatefulWidget {
  @override
  _MySubjectsPageState createState() => _MySubjectsPageState();
}

class _MySubjectsPageState extends State<MySubjectsPage> {
  final StudentController _controller = StudentController();
  List<CurriculumModulesModel> _registeredModules = [];
  bool _isLoading = true;
  final String matricId = "CB23048";
  String _selectedTab = "Curriculum Modules"; // "Academic Subjects" or "Curriculum Modules"

  @override
  void initState() {
    super.initState();
    _loadRegisteredModules();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRegisteredModules();
  }

  Future<void> _loadRegisteredModules() async {
    setState(() => _isLoading = true);
    _registeredModules = await _controller.getRegisteredSubjects("CB23048");
    setState(() => _isLoading = false);
  }

  // Beautiful Custom Success Popup matching "M2 STUDENT (4).png"
  void _showSuccessPopup(String moduleCode, String moduleName, String date, String time) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });

        return Dialog(
          alignment: Alignment.topCenter,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), 
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MODULE DROPPED SUCCESSFULLY!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC62828), 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$moduleCode $moduleName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Class Date: $date',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _dropModule(String moduleId, String moduleCode, String moduleName, String date, String time) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text('Drop Module'),
          content: Text('Are you sure you want to drop $moduleName on $date?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('DROP'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _controller.dropSubject(moduleId);
      _showSuccessPopup(moduleCode, moduleName.toUpperCase(), date, time);
      _loadRegisteredModules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE1E9F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
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

            // Banner Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Text(
                    'MY SUBJECTS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Tab Selection Pills
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = "Academic Subjects";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedTab == "Academic Subjects"
                                    ? Colors.teal
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Academic Subjects',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _selectedTab == "Academic Subjects"
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = "Curriculum Modules";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedTab == "Curriculum Modules"
                                    ? Colors.teal
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Curriculum Modules',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _selectedTab == "Curriculum Modules"
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Registered List Body
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _registeredModules.isEmpty
                      ? const Center(
                          child: Text(
                            'No registered modules',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: _registeredModules.length,
                          itemBuilder: (context, index) {
                            final module = _registeredModules[index];
                            final firstSlot = module.scheduleSlots.isNotEmpty
                                ? module.scheduleSlots[0]
                                : {'date': 'N/A', 'startTime': 'N/A', 'endTime': 'N/A'};

                            String dateText = firstSlot['date'] ?? 'N/A';
                            String timeText = '${firstSlot['startTime']} - ${firstSlot['endTime']}';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F5FA),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${module.ModuleCode}  ${module.ModuleName.toUpperCase()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Class Date: $dateText',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      timeText,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _dropModule(
                                            module.ModuleID,
                                            module.ModuleCode,
                                            module.ModuleName,
                                            dateText,
                                            timeText,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0066CC), // Precise bright blue from reference image
                                          foregroundColor: Colors.white,
                                          elevation: 2, // Matches elevation depth from your visual snippet
                                          minimumSize: const Size(90, 36),
                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                          shape: const StadiumBorder(), // Perfect stadium-rounded button style
                                        ),
                                        child: const Text(
                                          'DROP',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}