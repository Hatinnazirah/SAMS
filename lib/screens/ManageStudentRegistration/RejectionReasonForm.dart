import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';
import 'package:sams_app/controllers/ManageStudentRegistration/RegistrationController.dart';

class RejectionReasonForm extends StatefulWidget {
  final RegistrationModel registration;

  const RejectionReasonForm({super.key, required this.registration});

  @override
  State<RejectionReasonForm> createState() => _RejectionReasonFormState();
}

class _RejectionReasonFormState extends State<RejectionReasonForm> {
  final RegistrationController _controller = RegistrationController();
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRejection() async {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a rejection reason'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _controller.updateRegistrationStatus(
      widget.registration.registrationId,
      RegistrationStatus.reject,
      reason,
    );

    setState(() => _isLoading = false);

    if (result == 'success') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration rejected'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color mapping following mock styling rule guidelines 
    const Color surfaceWhiteCard = Colors.white;
    const Color actionBlue = Color(0xFF1570D5);

    return Scaffold(
      backgroundColor: const Color(0xD994A3B8),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceWhiteCard,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Header Title Display
                const Center(
                  child: Text(
                    'REJECTION REASON',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form label title block
                const Text(
                  'Reason:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Multi-line Reason Input Window Box 
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 160,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: null, // Dynamic sizing wrapped internally
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Enter reason of rejection here',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Center aligned Capsule Submission action item
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitRejection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SUBMIT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
