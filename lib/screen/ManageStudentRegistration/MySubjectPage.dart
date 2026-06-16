import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controller/ManageStudentRegistration/RegistrationController.dart';
import 'DropSubjectPage.dart';

class MySubjectPage extends StatefulWidget {
  const MySubjectPage({super.key});

  @override
  State<MySubjectPage> createState() => _MySubjectPageState();
}

class _MySubjectPageState extends State<MySubjectPage> {
  final RegistrationController _controller = RegistrationController();
  List<RegistrationModel> _registrations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRegisteredSubjects();
  }

  Future<void> _loadRegisteredSubjects() async {
    setState(() => _isLoading = true);
    _registrations = await _controller.getRegisteredSubjects('STUDENT001');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Exactly matches the system baby blue background canvas color
      backgroundColor: const Color(0xFFDDE7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Layout Header Block matching the design system blueprint
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 26,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'MY SUBJECTS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Academic/Curriculum Subject Selection Custom Tabs
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFBFCAD6,
                      ), // Inactive gray-blue background pill
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Academic Subjects',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Curriculum Subjects',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A6E7F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Primary Content Block - Render Core Dynamic Subject Canvas List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB21212),
                      ),
                    )
                  : _registrations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 54,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No Registered Subjects Listed',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      itemCount: _registrations.length,
                      itemBuilder: (context, index) {
                        final registration = _registrations[index];

                        // Mock section assignments safely when properties map empty parameters
                        String lectureSection = "01";
                        String labSection = "01A";

                        // Dynamic check to support edge structures like Undergraduate Project
                        if (registration.subjectCode.toUpperCase().contains(
                          "BCC3012",
                        )) {
                          lectureSection = "01";
                          labSection = "-";
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Left Column Content: Subject Metadata Fields
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Subject Code & System String Title
                                    Text(
                                      '${registration.subjectCode}  ${registration.subjectName.toUpperCase()}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Lecture Section Subfield Layout Details
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 109, 109, 109),
                                          fontSize: 16,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Lecture Section: ',
                                          ),
                                          TextSpan(
                                            text: lectureSection,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(255, 109, 109, 109),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Lab Section Subfield Layout Details
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 109, 109, 109),
                                          fontSize: 16,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Lab Section: '),
                                          TextSpan(
                                            text: labSection,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(255, 109, 109, 109),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Column Content: Status Indicator Tag alongside Drop Action Pill
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Status Approval Indicator text weight line
                                  Text(
                                    index == 0 ? 'Pending Approval' : 'Approve',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: index == 0
                                          ? const Color.fromARGB(255, 107, 107, 107) // Pending Approval Silver
                                          : const Color.fromARGB(255, 76, 209, 83), // Approve Green Tone
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Exact Mini Rounded Pillar DROP Call-To-Action Button Block
                                  SizedBox(
                                    height: 34,
                                    width: 82,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DropSubjectPage(
                                              registration: registration,
                                            ),
                                          ),
                                        ).then(
                                          (_) => _loadRegisteredSubjects(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 199, 24, 24), // Deep crimson red
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'DROP',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
