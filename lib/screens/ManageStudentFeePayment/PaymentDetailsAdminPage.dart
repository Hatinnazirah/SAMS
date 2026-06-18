import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RecordPaymentPage.dart';

class PaymentDetailsAdminPage extends StatelessWidget {
  final String studentID;

  const PaymentDetailsAdminPage({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAYMENT DETAILS",
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
        builder: (context, feeSnapshot) {

          if (feeSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!feeSnapshot.hasData ||
              feeSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Fee Record Found",
              ),
            );
          }

          final fee =
              feeSnapshot.data!.docs.first.data()
                  as Map<String, dynamic>;

          String feeStatus =
              fee['FeeStatus'] ?? '';

          double totalFee =
              double.tryParse(
                    fee['TotalFee'].toString(),
                  ) ??
                  0;

          double remainingAmount =
              double.tryParse(
                    fee['RemainingAmount']
                        .toString(),
                  ) ??
                  0;

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('Payment')
                .where(
                  'StudentID',
                  isEqualTo: studentID,
                )
                .get(),
            builder: (context, paymentSnapshot) {

              String paymentMethod =
                  "Not Available";

              if (paymentSnapshot.hasData &&
                  paymentSnapshot
                      .data!.docs.isNotEmpty) {

                final latestPayment =
                    paymentSnapshot
                        .data!.docs.last
                        .data()
                    as Map<String, dynamic>;

                paymentMethod =
                    latestPayment[
                            'PaymentMethod'] ??
                        "Not Available";
              }

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

                    const SizedBox(height: 25),

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
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            const Text(
                              "Student Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            Text(
                              "Student ID : $studentID",
                            ),

                            const Text(
                              "Name : Ain Safiya Binti Zulkamal",
                            ),

                            Text(
                              "Status : $feeStatus",
                            ),

                            Text(
                              "Total Fee : RM ${totalFee.toStringAsFixed(2)}",
                            ),

                            Text(
                              "Outstanding Balance : RM ${remainingAmount.toStringAsFixed(2)}",
                            ),

                            Text(
                              "Payment Method : $paymentMethod",
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.amber,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Notification sent to student",
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "NOTIFY STUDENT",
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Student registration restricted",
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "RESTRICT REGISTRATION",
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecordPaymentPage(
                                studentID:
                                    studentID,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "PAYMENT RECORD",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}