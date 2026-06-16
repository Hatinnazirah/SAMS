import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controller/ManageStudentRegistration/RegistrationController.dart';
import 'SubjectApprovalPage.dart';

class ManageRegistrationPage extends StatefulWidget {
  const ManageRegistrationPage({super.key});

  @override
  State<ManageRegistrationPage> createState() => _ManageRegistrationPageState();
}

class _ManageRegistrationPageState extends State<ManageRegistrationPage> {
  final RegistrationController _controller = RegistrationController();
  List<RegistrationModel> _pendingRegistrations = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.initMockData();
    _loadPendingRegistrations();
  }

  Future<void> _loadPendingRegistrations() async {
    setState(() => _isLoading = true);
    _pendingRegistrations = await _controller.getAllStudentRegistrations();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Exact color matching from the layout image provided
    const Color pageBackgroundColor = Color(0xFFDEE6F5); 
    const Color inputFieldFillColor = Color(0xFFC7D3E5);
    const Color darkText = Colors.black;

    final filteredRegistrations = _pendingRegistrations.where((reg) {
      final query = _searchQuery.toLowerCase();
      return reg.subjectCode.toLowerCase().contains(query) ||
             reg.subjectName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: darkText, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Title Header Text
            const Text(
              'MANAGE REGISTRATION',
              style: TextStyle(
                color: darkText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // UMPSA Brand Logo Asset Container
            Container(
              width: 105,
              height: 105,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/SAMS LOGO.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF0F3460),
                      child: const Icon(
                        Icons.school,
                        size: 34,
                        color: Color(0xFF76C4EE),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Search Bar Input Element Layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: inputFieldFillColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF5A6B82), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: const TextStyle(color: Color(0xFF334155), fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'code or subject name',
                          hintStyle: TextStyle(color: Color(0xFF5A6B82), fontSize: 16),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Registration Dynamic Item Feed List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredRegistrations.isEmpty
                      ? const Center(
                          child: Text(
                            'No matching registration tracks',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredRegistrations.length,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemBuilder: (context, index) {
                            final registration = filteredRegistrations[index];
                            
                            // Emulating the custom static notification counts shown on your mockup image preview
                            final List<int> mockBadgeNumbers = [3, 1, 2, 3, 5, 5, 7, 3, 1, 4];
                            final int currentBadgeValue = mockBadgeNumbers[index % mockBadgeNumbers.length];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubjectApprovalPage(registration: registration),
                                    ),
                                  ).then((_) => _loadPendingRegistrations());
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Subject Details Presentation Left Alignment
                                      Expanded(
                                        child: Text(
                                          '${registration.subjectCode}  ${registration.subjectName.toUpperCase()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      
                                      // Right Aligned Circular Badge Notification Element
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF30000),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$currentBadgeValue',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
    );
  }
}