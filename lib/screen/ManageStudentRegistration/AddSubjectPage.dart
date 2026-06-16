import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controller/ManageStudentRegistration/RegistrationController.dart';

class AddSubjectPage extends StatefulWidget {
  final SubjectModel subject;

  const AddSubjectPage({super.key, required this.subject});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final RegistrationController _controller = RegistrationController();
  String? _loadingSection; // Track which section is loading (e.g., "01A", "01B", etc.)
  String? _errorMessage;

  // Custom Success Alert Box Matching image_db7a14.png Exactly
  void _showSuccessDialog(String lectureSection, String labSection) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ADDED SUCCESSFULLY !',
                  style: TextStyle(
                    color: Color(0xFF00C853), // Vivid green match
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.subject.subjectCode} ${widget.subject.subjectName.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 99, 99, 99),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Color.fromARGB(255, 99, 99, 99), fontSize: 16),
                    children: [
                      const TextSpan(text: 'Lecture Section: '),
                      TextSpan(
                        text: lectureSection,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Color.fromARGB(255, 99, 99, 99), fontSize: 16),
                    children: [
                      const TextSpan(text: 'Lab Section: '),
                      TextSpan(
                        text: labSection,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Pop back to Subject List screen and update available lists once closed
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _confirmAddSubject(
    String lectureSection,
    String labSection,
  ) async {
    setState(() {
      _loadingSection = labSection; // Track which section is loading
      _errorMessage = null;
    });

    final result = await _controller.addSubject(
      'STUDENT001', // Session Mock Key
      widget.subject.subjectId,
      lectureSection: lectureSection,
      labSection: labSection,
    );

    setState(() => _loadingSection = null);

    if (result == 'success') {
      if (mounted) {
        _showSuccessDialog(lectureSection, labSection);
      }
    } else {
      setState(() => _errorMessage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayCode = widget.subject.subjectCode;
    final String displayName = widget.subject.subjectName.toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD), // Light system blue base canvas
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Structural Header Control Element
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
                    'SUBJECT REGISTRATION',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Dynamic Subject Section Matrix
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                children: [
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  _buildSectionCard(
                    subjectCodeAndName: '$displayCode  $displayName',
                    lectureSection: '01',
                    lectureSlots: '(40/60)',
                    labSection: '01A',
                    labSlots: '(25/30)',
                    onAddPressed: () => _confirmAddSubject('01', '01A'),
                    isLoading: _loadingSection == '01A',
                  ),
                  _buildSectionCard(
                    subjectCodeAndName: '$displayCode  $displayName',
                    lectureSection: '01',
                    lectureSlots: '(40/60)',
                    labSection: '01B',
                    labSlots: '(15/30)',
                    onAddPressed: () => _confirmAddSubject('01', '01B'),
                    isLoading: _loadingSection == '01B',
                  ),
                  _buildSectionCard(
                    subjectCodeAndName: '$displayCode  $displayName',
                    lectureSection: '02',
                    lectureSlots: '(50/60)',
                    labSection: '02A',
                    labSlots: '(15/30)',
                    onAddPressed: () => _confirmAddSubject('02', '02A'),
                    isLoading: _loadingSection == '02A',
                  ),
                  _buildSectionCard(
                    subjectCodeAndName: '$displayCode  $displayName',
                    lectureSection: '02',
                    lectureSlots: '(50/60)',
                    labSection: '02B',
                    labSlots: '(15/30)',
                    onAddPressed: () => _confirmAddSubject('02', '02B'),
                    isLoading: _loadingSection == '02B',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String subjectCodeAndName,
    required String lectureSection,
    required String lectureSlots,
    required String labSection,
    required String labSlots,
    required VoidCallback onAddPressed,
    required bool isLoading,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subjectCodeAndName,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lecture $lectureSection $lectureSlots',
                  style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 104, 104, 104)),
                ),
              ),
              Expanded(
                child: Text(
                  'Lab $labSection $labSlots',
                  style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 104, 104, 104)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAddPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F74E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'ADD',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
