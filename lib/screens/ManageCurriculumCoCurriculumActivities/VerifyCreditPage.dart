import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/PusatAdabController.dart';
import 'CreditClaimListPage.dart';

class VerifyCreditPage extends StatefulWidget {
  const VerifyCreditPage({super.key});

  @override
  _VerifyCreditPageState createState() => _VerifyCreditPageState();
}

class _VerifyCreditPageState extends State<VerifyCreditPage> {
  final PusatAdabController _controller = PusatAdabController();
  List<Map<String, dynamic>> _faculties = [];
  bool _isLoading = true;
  final String staffId = "PUSAT ADAB";

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    setState(() => _isLoading = true);
    _faculties = await _controller.getCreditClaimsList();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4), // Clean background tint matching layout
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Navigation Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          staffId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // UI Screen Header Title
              const Text(
                'VERIFY CREDIT',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 25),
              
              // Centered Application Logo
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/sams_logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // Dynamic List View Blocks
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_faculties.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      'No pending credit claims',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _faculties.map((faculty) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F5FA), // Off-white color fill matching reference UI cards
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreditClaimListPage(
                                    facultyName: faculty['facultyName'],
                                    claims: faculty['claims'] ?? [],
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Faculty Text Label Content Area
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12.0), // Correct padding configuration
                                      child: Text(
                                        faculty['facultyName'].toString().toUpperCase(),
                                        textAlign: TextAlign.center, // Matches centered horizontal pattern
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212121), // Standardized clean text color
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Notifications Numeric Badge Overlay
                                  Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE51C23), // Vibrant crimson notification red
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${faculty['pendingCount']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
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