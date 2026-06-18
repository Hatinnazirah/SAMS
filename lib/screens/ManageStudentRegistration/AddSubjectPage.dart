import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';

class AddSubjectPage extends StatefulWidget {
  final SubjectModel subject;
  final String? studentId;

  const AddSubjectPage({
    super.key, 
    required this.subject,
    this.studentId,
  });

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final RegistrationController _controller = RegistrationController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? _loadingSection;
  String? _errorMessage;
  
  List<Map<String, dynamic>> _sections = [];
  bool _isLoadingSections = true;
  
  String _venue = '';
  String _lecturerName = '';
  int _maxCapacity = 0;
  int _currentEnrolled = 0;
  
  String get _studentId => widget.studentId ?? 'CB23048';

  @override
  void initState() {
    super.initState();
    _loadSectionsFromFirebase();
  }

  List<String> _arrayToList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  String _arrayToString(dynamic value) {
    if (value == null) return 'N/A';
    if (value is List) {
      return value.isNotEmpty ? value[0].toString() : 'N/A';
    }
    return value.toString();
  }

  Map<String, dynamic> _getScheduleForLab(
    Map<String, dynamic> data, 
    String labSection
  ) {
    final List<dynamic> scheduleLab = data['ScheduleLab'] ?? [];
    
    for (var schedule in scheduleLab) {
      if (schedule['LabSection'] == labSection) {
        return {
          'day': schedule['Day'] ?? 'N/A',
          'startTime': schedule['StartTime'] ?? 'N/A',
          'endTime': schedule['EndTime'] ?? 'N/A',
        };
      }
    }
    
    return {
      'day': _arrayToString(data['ScheduleDay']),
      'startTime': _arrayToString(data['ScheduleStartTime']),
      'endTime': _arrayToString(data['ScheduleEndTime']),
    };
  }

  Future<void> _loadSectionsFromFirebase() async {
    setState(() {
      _isLoadingSections = true;
      _errorMessage = null;
    });

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Subject')
          .where('SubjectID', isEqualTo: widget.subject.subjectId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _isLoadingSections = false;
          _errorMessage = 'Subject not found in Firebase';
        });
        return;
      }

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      
      _currentEnrolled = _toInt(data['CurrentEnrolled']);
      _maxCapacity = _toInt(data['MaxCapacity']);
      _venue = data['Venue'] ?? 'N/A';
      _lecturerName = data['LecturerName'] ?? 'N/A';

      final List<String> lectureSections = _arrayToList(data['LectureSection']);
      final List<String> labSections = _arrayToList(data['LabSection']);

      if (lectureSections.isEmpty) {
        setState(() {
          _isLoadingSections = false;
          _errorMessage = 'No lecture sections found in Firebase.';
        });
        return;
      }
      
      if (labSections.isEmpty) {
        setState(() {
          _isLoadingSections = false;
          _errorMessage = 'No lab sections found in Firebase.';
        });
        return;
      }

      final List<Map<String, dynamic>> generatedSections = [];

      for (var lecture in lectureSections) {
        for (var lab in labSections) {
          final int available = _maxCapacity - _currentEnrolled;
          final schedule = _getScheduleForLab(data, lab);
          
          generatedSections.add({
            'lectureSection': lecture,
            'labSection': lab,
            'currentEnrolled': _currentEnrolled,
            'maxCapacity': _maxCapacity,
            'availableSlots': available > 0 ? available : 0,
            'isFull': available <= 0,
            'scheduleDay': schedule['day'],
            'scheduleStartTime': schedule['startTime'],
            'scheduleEndTime': schedule['endTime'],
          });
        }
      }

      setState(() {
        _sections = generatedSections;
        _isLoadingSections = false;
      });

      print('✅ Loaded ${_sections.length} sections for student: $_studentId');

    } catch (e) {
      setState(() {
        _isLoadingSections = false;
        _errorMessage = 'Error loading from Firebase: $e';
      });
      print('❌ Error: $e');
    }
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

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
                    color: Color(0xFF00C853),
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
      _loadingSection = labSection;
      _errorMessage = null;
    });

    final result = await _controller.addSubject(
      _studentId,
      widget.subject.subjectId,
      lectureSection: lectureSection,
      labSection: labSection,
    );

    setState(() => _loadingSection = null);

    if (result == 'success') {
      if (mounted) {
        _showSuccessDialog(lectureSection, labSection);
        await _loadSectionsFromFirebase();
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
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Lecturer: $_lecturerName',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Venue: $_venue',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.group, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Capacity: $_currentEnrolled / $_maxCapacity students',
                            style: TextStyle(
                              fontSize: 14,
                              color: _currentEnrolled >= _maxCapacity ? Colors.red : Colors.grey,
                              fontWeight: _currentEnrolled >= _maxCapacity ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _isLoadingSections
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
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
                        if (_sections.isEmpty && !_isLoadingSections) ...[
                          const Center(
                            child: Text(
                              'No sections available for this subject in Firebase.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                        ..._sections.map((section) => _buildSectionCard(
                          subjectCodeAndName: '$displayCode  $displayName',
                          lectureSection: section['lectureSection'] ?? 'N/A',
                          lectureSlots: '(${section['currentEnrolled']}/${section['maxCapacity']})',
                          labSection: section['labSection'] ?? 'N/A',
                          labSlots: '${section['availableSlots']} slots available',
                          scheduleDay: section['scheduleDay'] ?? 'N/A',
                          scheduleStartTime: section['scheduleStartTime'] ?? 'N/A',
                          scheduleEndTime: section['scheduleEndTime'] ?? 'N/A',
                          onAddPressed: () => _confirmAddSubject(
                            section['lectureSection'] ?? 'N/A',
                            section['labSection'] ?? 'N/A',
                          ),
                          isLoading: _loadingSection == section['labSection'],
                          isAvailable: (section['availableSlots'] ?? 0) > 0,
                        )),
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
    required String scheduleDay,
    required String scheduleStartTime,
    required String scheduleEndTime,
    required VoidCallback onAddPressed,
    required bool isLoading,
    required bool isAvailable,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
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
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '$scheduleDay $scheduleStartTime - $scheduleEndTime',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                  'Lab $labSection ($labSlots)',
                  style: TextStyle(
                    fontSize: 16,
                    color: isAvailable ? const Color.fromARGB(255, 104, 104, 104) : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: (isAvailable && !isLoading) ? onAddPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable ? const Color(0xFF0F74E9) : Colors.grey,
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
                  : Text(
                      isAvailable ? 'ADD' : 'FULL',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}