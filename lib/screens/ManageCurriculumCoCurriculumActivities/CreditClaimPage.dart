import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/StudentController.dart';

class CreditClaimPage extends StatefulWidget {
  @override
  _CreditClaimPageState createState() => _CreditClaimPageState();
}

class _CreditClaimPageState extends State<CreditClaimPage> {
  final String matricId = "CB23048";
  final StudentController _controller = StudentController();
  bool _isLoading = true;
  bool _isSubmitting = false;

  List<Map<String, dynamic>> _claimableModules = [];

  @override
  void initState() {
    super.initState();
    _loadClaimableModules();
  }

  Future<void> _loadClaimableModules() async {
    setState(() => _isLoading = true);
    _claimableModules = await _controller.getClaimableModules(matricId);
    setState(() => _isLoading = false);
  }

  void _toggleSelection(int index) {
    setState(() {
      _claimableModules[index]['isSelected'] =
          !(_claimableModules[index]['isSelected'] ?? false);
    });
  }

  void _selectAll() {
    setState(() {
      for (var module in _claimableModules) {
        if (module['claimStatus'] == 'not_claimed') {
          module['isSelected'] = true;
        }
      }
    });
  }

  void _deselectAll() {
    setState(() {
      for (var module in _claimableModules) {
        module['isSelected'] = false;
      }
    });
  }

  Future<void> _submitClaims() async {
    List<Map<String, dynamic>> selectedModules = _claimableModules
        .where((m) => m['isSelected'] == true)
        .toList();

    if (selectedModules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one module to claim'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    bool allSuccess = true;

    for (var module in selectedModules) {
      bool success = await _controller.submitCreditClaim(
        matricId,
        module['moduleCode'],
        module['credits'] ?? 1,
      );
      if (!success) {
        allSuccess = false;
      }
    }

    setState(() {
      _isSubmitting = false;
    });

    if (allSuccess) {
      _showSuccessDialog(selectedModules.length);
      _loadClaimableModules();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some claims failed to submit. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(int count) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Color(0xFF00B000),
                ),
                const SizedBox(height: 16),
                const Text(
                  'CLAIM SUBMITTED SUCCESSFULLY!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B000),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count credit claim(s) have been submitted for approval.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Waiting for Pusat Adab to approve.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    if (status == 'pending') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'PENDING',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
      );
    } else if (status == 'approve' || status == 'approved') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'APPROVED ✓',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      );
    } else if (status == 'reject' || status == 'rejected') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'REJECTED ✗',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Text(
                        matricId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Text(
              'CREDIT CLAIM',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Select All / Deselect All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _selectAll,
                    child: const Text('SELECT ALL'),
                  ),
                  TextButton(
                    onPressed: _deselectAll,
                    child: const Text('DESELECT ALL'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _claimableModules.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card_off,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No modules available for credit claim',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Complete and get graded first',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadClaimableModules,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: _claimableModules.length,
                            itemBuilder: (context, index) {
                              final module = _claimableModules[index];
                              final claimStatus = module['claimStatus'] ?? 'not_claimed';
                              final isClaimed = claimStatus != 'not_claimed';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      if (!isClaimed)
                                        Checkbox(
                                          value: module['isSelected'] ?? false,
                                          onChanged: (value) =>
                                              _toggleSelection(index),
                                          activeColor: const Color(0xFF1976D2),
                                        )
                                      else
                                        const SizedBox(width: 40),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${module['moduleCode']}  ${module['moduleName']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              module['activityName'] ?? 'Activity',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'Credits: ${module['credits']}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                if (module['score'] != null)
                                                  Text(
                                                    'Score: ${module['score']}/100',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.green[700],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            if (claimStatus == 'pending')
                                              const Text(
                                                'Waiting for verification...',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            if (claimStatus == 'approve' ||
                                                claimStatus == 'approved')
                                              const Text(
                                                'Credit approved!',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            if (claimStatus == 'reject' ||
                                                claimStatus == 'rejected')
                                              const Text(
                                                'Credit rejected',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      if (isClaimed)
                                        _buildStatusChip(claimStatus)
                                      else
                                        ElevatedButton(
                                          onPressed: () => _toggleSelection(index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                module['isSelected'] == true
                                                ? const Color(0xFF00B000)
                                                : const Color(0xFF1976D2),
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(70, 32),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                18,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            module['isSelected'] == true
                                                ? 'SELECTED'
                                                : 'CLAIM',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
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
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitClaims,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
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