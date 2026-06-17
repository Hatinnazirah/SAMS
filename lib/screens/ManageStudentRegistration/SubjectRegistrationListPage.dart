import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';
import 'AddSubjectPage.dart';

// Remove overscroll glow for a smoother feel
class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SubjectRegistrationListPage extends StatefulWidget {
  final String? studentId;
  final String? studentName;
  final String? matricId;

  const SubjectRegistrationListPage({
    super.key,
    this.studentId,
    this.studentName,
    this.matricId,
  });

  @override
  State<SubjectRegistrationListPage> createState() =>
      _SubjectRegistrationListPageState();
}

class _SubjectRegistrationListPageState
    extends State<SubjectRegistrationListPage> {
  final RegistrationController _controller = RegistrationController();
  List<SubjectModel> _subjects = [];
  List<SubjectModel> _filteredSubjects = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  
  late String _studentId;

  @override
  void initState() {
    super.initState();
    _initializeStudentData();
    _loadSubjects();
  }

  void _initializeStudentData() {
    _studentId = widget.studentId ?? 'CB23048';
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    _subjects = await _controller.getAvailableSubjects();
    _applySearchFilter();
    setState(() => _isLoading = false);
  }

  void _applySearchFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _filteredSubjects = query.isEmpty
        ? List<SubjectModel>.from(_subjects)
        : _subjects.where((subject) {
            final code = subject.subjectCode.toLowerCase();
            final name = subject.subjectName.toLowerCase();
            return code.contains(query) || name.contains(query);
          }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Custom Clean Top App Bar - SAME AS BEFORE
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'SUBJECT REGISTRATION',
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

            // ✅ Mini Circular Branding Emblem - SAME
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/SAMS LOGO.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1E3A60),
                      child: const Icon(
                        Icons.school,
                        size: 35,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Search Bar - SAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD6E2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF555555),
                      size: 22,
                    ),
                    hintText: 'code or subject name',
                    hintStyle: TextStyle(
                      color: Color(0xFF6C7B8E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                  ),
                  onChanged: (value) {
                    setState(_applySearchFilter);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Subject List - SAME
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadSubjects,
                      child: _filteredSubjects.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 140),
                                Center(
                                  child: Text(
                                    _searchController.text.trim().isEmpty
                                        ? 'No subjects available for registration'
                                        : 'No subjects match your search',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ScrollConfiguration(
                              behavior: const NoGlowScrollBehavior(),
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 8.0,
                                ),
                                itemCount: _filteredSubjects.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final subject = _filteredSubjects[index];
                                  return Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: subject.availableSlots > 0
                                            ? () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => AddSubjectPage(
                                                      subject: subject,
                                                      studentId: _studentId,
                                                    ),
                                                  ),
                                                ).then((_) => _loadSubjects())
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0,
                                            vertical: 16.0,
                                          ),
                                          child: Text(
                                            '${subject.subjectCode}  ${subject.subjectName.toUpperCase()}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF2C3E50),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}