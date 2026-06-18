import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PaymentSuccessPage.dart';

class PaymentConfirmationPage extends StatelessWidget {
  final String studentID;
  final String paymentMethod;

  const PaymentConfirmationPage({
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
          "CONFIRM PAYMENT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Fee')
            .where(
              'StudentID',
              isEqualTo: studentID,
            )
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Fee Record Found",
              ),
            );
          }

          final feeDoc =
              snapshot.data!.docs.first;

          final fee =
              feeDoc.data()
                  as Map<String, dynamic>;

          double remainingAmount =
              double.tryParse(
                    fee['RemainingAmount']
                        .toString(),
                  ) ??
                  0;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      const AssetImage(
                    'assets/icons/sams_logo.png',
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            20),
                    child: Column(
                      children: [

                        const Text(
                          "Payment Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Student ID",
                            ),

                            Text(
                              studentID,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Amount",
                            ),

                            Text(
                              "RM ${remainingAmount.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Payment Method",
                            ),

                            Text(
                              paymentMethod,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue,
                              foregroundColor:
                                  Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            onPressed:
                                () async {

                              try {

                                String paymentID =
                                    "PAY${DateTime.now().millisecondsSinceEpoch}";

                                await FirebaseFirestore
                                    .instance
                                    .collection(
                                        'Payment')
                                    .add({
                                  'PaymentID':
                                      paymentID,
                                  'StudentID':
                                      studentID,
                                  'Amount':
                                      remainingAmount,
                                  'PaymentMethod':
                                      paymentMethod,
                                  'PaymentStatus':
                                      'Success',
                                  'PaymentDate':
                                      Timestamp.now(),
                                });

                                await FirebaseFirestore
                                    .instance
                                    .collection(
                                        'Fee')
                                    .doc(
                                        feeDoc.id)
                                    .update({
                                  'RemainingAmount':
                                      0,
                                  'FeeStatus':
                                      'Paid',
                                  'PaidAmount':
                                      fee[
                                              'TotalFee'] ??
                                          remainingAmount,
                                });

                                if (context
                                    .mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              PaymentSuccessPage(
                                        studentID:
                                            studentID,
                                        paymentMethod:
                                            paymentMethod,
                                      ),
                                    ),
                                  );
                                }

                              } catch (e) {

                                ScaffoldMessenger
                                        .of(
                                            context)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(
                                      "Payment Failed: $e",
                                    ),
                                  ),
                                );
                              }
                            },
                            child:
                                const Text(
                              "Confirm Payment",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}