import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/PusatAdabController.dart';

class CreditClaimListPage extends StatefulWidget {
  final String facultyName;
  final List<Map<String, dynamic>> claims;

  const CreditClaimListPage({
    super.key,
    required this.facultyName,
    required this.claims,
  });

  @override
  _CreditClaimListPageState createState() => _CreditClaimListPageState();
}

class _CreditClaimListPageState extends State<CreditClaimListPage> {
  final PusatAdabController _controller = PusatAdabController();
  final String staffId = "PUSAT ADAB";
  
  // Local list of claims to manage UI updates locally upon validation actions
  late List<Map<String, dynamic>> _claimsList;

  @override
  void initState() {
    super.initState();
    _claimsList = List.from(widget.claims);
  }

  Future<void> _updateSingleClaimStatus(String claimId, String status, int localIndex) async {
    await _controller.validateAndUpdateClaimStatus(claimId, status, "STAFF001");
    
    setState(() {
      _claimsList.removeAt(localIndex);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Claim ${status == 'approve' ? 'approved' : 'rejected'} successfully'),
        backgroundColor: status == 'approve' ? const Color(0xFF00A651) : const Color(0xFFC61919),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                    onPressed: () => Navigator.pop(context),
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

            // Header Title
            const Text(
              'VERIFY CREDIT',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            
            // Faculty Name Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                widget.facultyName.toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6E7A8A),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Claims List
            Expanded(
              child: _claimsList.isEmpty
                  ? const Center(
                      child: Text(
                        'No pending claims in this faculty',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _claimsList.length,
                      itemBuilder: (context, index) {
                        final claim = _claimsList[index];
                        
                        // Extract Student Name, Student ID, and Faculty Name
                        String studentName = (claim['studentName'] ?? claim['studentFullName'] ?? 'UNKNOWN STUDENT').toString().toUpperCase();
                        String studentId = (claim['studentId'] ?? claim['studentMatric'] ?? claim['matricNo'] ?? '').toString().toUpperCase();
                        String studentFaculty = (claim['studentFaculty'] ?? claim['facultyName'] ?? '').toString().toUpperCase();

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F5FA),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Student Name
                                Text(
                                  studentName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                
                                // Student ID
                                Text(
                                  studentId,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                
                                // Faculty Name
                                Text(
                                  studentFaculty,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF8A95A5),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Action Buttons (Reject & Approve)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // REJECT Button
                                    SizedBox(
                                      height: 36,
                                      width: 115,
                                      child: ElevatedButton(
                                        onPressed: () => _updateSingleClaimStatus(claim['claimId'] ?? '', 'reject', index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFC61919),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'REJECT',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // APPROVE Button
                                    SizedBox(
                                      height: 36,
                                      width: 115,
                                      child: ElevatedButton(
                                        onPressed: () => _updateSingleClaimStatus(claim['claimId'] ?? '', 'approve', index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF00A651),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'APPROVE',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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