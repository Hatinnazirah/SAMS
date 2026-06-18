import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';
import 'DropSubjectPage.dart';

class MySubjectPage extends StatefulWidget {
  final String? studentId;
  final String? studentName;
  final String? matricId;

  const MySubjectPage({
    super.key, 
    this.studentId,
    this.studentName,
    this.matricId,
  });

  @override
  State<MySubjectPage> createState() => _MySubjectPageState();
}

class _MySubjectPageState extends State<MySubjectPage> {
  final RegistrationController _controller = RegistrationController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<RegistrationModel> _registrations = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Get student ID from widget or use default
  String get _studentId => widget.studentId ?? 'CB23048';

  @override
  void initState() {
    super.initState();
    _loadRegisteredSubjects();
  }

  // ============ FIREBASE METHODS ============

  // Load registered subjects from Firebase - NO DUMMY DATA
  Future<void> _loadRegisteredSubjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load from Firebase using RegistrationController
      _registrations = await _controller.getRegisteredSubjects(_studentId);
      
      // If no registrations found, check if student exists
      if (_registrations.isEmpty) {
        final studentDoc = await _firestore
            .collection('User')
            .where('Username', isEqualTo: _studentId)
            .limit(1)
            .get();
        
        if (studentDoc.docs.isEmpty) {
          setState(() {
            _errorMessage = 'Student not found in Firebase. Please check your ID.';
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
      
      print('✅ Loaded ${_registrations.length} registrations from Firebase for student: $_studentId');
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading registrations from Firebase: $e';
      });
      print('❌ Error loading registrations from Firebase: $e');
    }
  }

  // ============ UI METHODS ============

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            // Academic/Curriculum Subject Selection Tabs
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
                      color: const Color(0xFFBFCAD6),
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

            // Main Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB21212),
                      ),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 54,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loadRegisteredSubjects,
                            child: const Text('Retry'),
                          ),
                        ],
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
                            'No Registered Subjects Found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You have not registered for any subjects yet.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
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

                        // Get lecture and lab sections from Firebase data
                        final String lectureSection = registration.lectureSection ?? 'N/A';
                        final String labSection = registration.labSection ?? 'N/A';

                        // Get status from Firebase
                        final String statusText = registration.getStatusDisplay();
                        final Color statusColor = registration.getStatusBadgeColor();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Left Column: Subject Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    // Credit Hours
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 109, 109, 109),
                                          fontSize: 14,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Credit Hours: '),
                                          TextSpan(
                                            text: '${registration.creditHours}',
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

                              // Right Column: Status + Drop Button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Status Indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Drop Button (only if status is pending or approved)
                                  if (registration.status != RegistrationStatus.reject)
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
                                          backgroundColor: const Color.fromARGB(255, 199, 24, 24),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
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