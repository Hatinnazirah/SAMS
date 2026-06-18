import 'package:flutter/material.dart';
import 'PaymentHistoryPage.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String studentID;
  final String paymentMethod;

  const PaymentSuccessPage({
    super.key,
    required this.studentID,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAYMENT SUCCESS",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Student ID : $studentID",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Payment Method : $paymentMethod",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Payment Completed Successfully",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1976D2),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentHistoryPage(
                            studentID:
                                studentID,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View Receipt",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
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