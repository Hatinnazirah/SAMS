import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controller/ManageStudentRegistration/RegistrationController.dart';

class ViewParticipantsPage extends StatefulWidget {
  const ViewParticipantsPage({super.key});

  @override
  State<ViewParticipantsPage> createState() => _ViewParticipantsPageState();
}

class _ViewParticipantsPageState extends State<ViewParticipantsPage> {
  final RegistrationController _controller = RegistrationController();
  List<SubjectModel> _subjects = [];
  List<RegistrationModel> _participants = [];
  bool _isLoadingSubjects = true;
  bool _isLoadingParticipants = false;

  @override
  void initState() {
    super.initState();
    _controller.initMockData();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoadingSubjects = true);
    _subjects = await _controller.getAvailableSubjects();
    setState(() => _isLoadingSubjects = false);
  }

  Future<void> _loadParticipants(String subjectId) async {
    setState(() => _isLoadingParticipants = true);
    _participants = await _controller.getSubjectParticipants(subjectId);
    setState(() => _isLoadingParticipants = false);
  }

  // Displays student participants matching the visual style of your popup modals
  void _showParticipantsModal(
    BuildContext context,
    SubjectModel subject,
  ) async {
    // Initiate non-blocking async payload fetch
    _loadParticipants(subject.subjectId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext colContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Re-sync parent async loading variables to modal view container
            if (_isLoadingParticipants) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) setModalState(() {});
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Color(0xFFDCE6F5), // System light-tint background
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  // Modal Pill Decorator Handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(110, 126, 149, 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Subject Code Header Identification
                  Text(
                    subject.subjectCode,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subject.subjectName.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF556477),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Enrolled counter label badge style
                  Text(
                    '${_participants.length} Active Participants',
                    style: const TextStyle(
                      color: Color(0xFF1570D5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 24,
                    color: Color(0xFFC9D6EA),
                    thickness: 1.2,
                  ),

                  // Core list dynamic state builder
                  Expanded(
                    child: _isLoadingParticipants
                        ? const Center(child: CircularProgressIndicator())
                        : _participants.isEmpty
                        ? const Center(
                            child: Text(
                              'No students registered yet',
                              style: TextStyle(
                                color: Color(0xFF6E7E95),
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _participants.length,
                            itemBuilder: (context, idx) {
                              final p = _participants[idx];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFC9D6EA),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFDCE6F5),
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF0A2E5C),
                                    ),
                                  ),
                                  title: Text(
                                    p.studentName.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    p.matricId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF556477),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Exact UI theme styling constants
    const Color pageBackgroundColor = Color(0xFFDCE6F5);
    const Color darkText = Colors.black;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navigation Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Title Header text matching application standard typography
              const Text(
                'VIEW PARTICIPANTS',
                style: TextStyle(
                  color: darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Official UI Circle branding element layout
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A2E5C),
                  shape: BoxShape.circle,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 30,
                      color: Color(0xFF7CD4FD),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'UMPSA',
                      style: TextStyle(
                        color: Color(0xFF7CD4FD),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'STUDENT ACADEMIC\nMANAGEMENT SYSTEM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 4.5,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Core Module Subjects Content Panel
              Expanded(
                child: _isLoadingSubjects
                    ? const Center(child: CircularProgressIndicator())
                    : _subjects.isEmpty
                    ? const Center(
                        child: Text(
                          'No courses available',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _subjects.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          final subject = _subjects[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GestureDetector(
                              onTap: () =>
                                  _showParticipantsModal(context, subject),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Layout code description elements
                                    Expanded(
                                      child: Text(
                                        '${subject.subjectCode}  ${subject.subjectName.toUpperCase()}',
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Forward chevron layout helper indicator icon
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF556477),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
