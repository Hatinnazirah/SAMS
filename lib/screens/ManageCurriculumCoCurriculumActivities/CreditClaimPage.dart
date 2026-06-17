import 'package:flutter/material.dart';

class CreditClaimPage extends StatefulWidget {
  @override
  _CreditClaimPageState createState() => _CreditClaimPageState();
}

class _CreditClaimPageState extends State<CreditClaimPage> {
  final String matricId = "CB23048";
  bool _isLoading = false;
  bool _isSubmitting = false;
  
  // REMOVED 'final' keyword so it can be modified
  List<Map<String, dynamic>> _completedModules = [
    {
      'id': '1',
      'moduleCode': 'HQD3062',
      'moduleName': 'EDIT LIKE A PRO WITH CANVA',
      'classDate': '2 May 2026',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 3,
      'isSelected': false,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '2',
      'moduleCode': 'HQP3022',
      'moduleName': 'PENGURUSAN MAJLIS',
      'classDate': '6/12/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 2,
      'isSelected': false,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '3',
      'moduleCode': 'UHS1221',
      'moduleName': 'THEATRE',
      'classDate': '31/05/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 1,
      'isSelected': false,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '4',
      'moduleCode': 'HQS3012',
      'moduleName': 'ASAS CATUR',
      'classDate': '24/05/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 2,
      'isSelected': false,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '5',
      'moduleCode': 'HQD3022',
      'moduleName': 'MOBILE PHONE PHOTOGRAPHY',
      'classDate': '21/12/2024',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 3,
      'isSelected': false,
      'claimStatus': 'not_claimed',
    },
  ];

  void _toggleSelection(int index) {
    setState(() {
      _completedModules[index]['isSelected'] = !_completedModules[index]['isSelected'];
    });
  }

  void _selectAll() {
    setState(() {
      for (var module in _completedModules) {
        if (module['claimStatus'] == 'not_claimed') {
          module['isSelected'] = true;
        }
      }
    });
  }

  void _deselectAll() {
    setState(() {
      for (var module in _completedModules) {
        module['isSelected'] = false;
      }
    });
  }

  Future<void> _submitClaims() async {
    List<Map<String, dynamic>> selectedModules = 
        _completedModules.where((m) => m['isSelected'] == true).toList();
    
    if (selectedModules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one module to claim')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      for (var module in selectedModules) {
        module['claimStatus'] = 'pending';
        module['isSelected'] = false;
      }
      _isSubmitting = false;
    });

    _showSuccessDialog(selectedModules.length);
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
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
    } else if (status == 'approved') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'APPROVED',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      );
    } else if (status == 'rejected') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'REJECTED',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
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
                      const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 20),
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
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _completedModules.length,
                      itemBuilder: (context, index) {
                        final module = _completedModules[index];
                        final isClaimed = module['claimStatus'] != 'not_claimed';
                        
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
                                    value: module['isSelected'],
                                    onChanged: (value) => _toggleSelection(index),
                                    activeColor: const Color(0xFF1976D2),
                                  )
                                else
                                  const SizedBox(width: 40),
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${module['moduleCode']} ${module['moduleName']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Class Date: ${module['classDate']}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                      ),
                                      Text(
                                        '${module['startTime']} - ${module['endTime']}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                      ),
                                      Text(
                                        'Credits: ${module['credits']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                if (isClaimed)
                                  _buildStatusChip(module['claimStatus'])
                                else
                                  ElevatedButton(
                                    onPressed: () => _toggleSelection(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1976D2),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(70, 32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      module['isSelected'] ? 'SELECTED' : 'CLAIM',
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