import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PaymentMethodPage.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String studentID;

  const PaymentDetailsPage({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAY TUITION FEE",
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

          final fee =
              snapshot.data!.docs.first.data()
                  as Map<String, dynamic>;

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

          double paidAmount =
              totalFee -
                  remainingAmount;

          double progress =
              totalFee == 0
                  ? 0
                  : paidAmount /
                      totalFee;

          String status =
              fee['FeeStatus'] ?? 'Unpaid';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage(
                    'assets/icons/sams_logo.png',
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        const Align(
                          alignment:
                              Alignment.centerLeft,
                          child: Text(
                            "Total Fee",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Align(
                          alignment:
                              Alignment.centerLeft,
                          child: Text(
                            "RM ${totalFee.toStringAsFixed(2)}",
                            style:
                                const TextStyle(
                              fontSize: 32,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                  10),
                          child:
                              LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            color:
                                Colors.green,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            Text(
                              "RM ${remainingAmount.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Chip(
                              label:
                                  Text(status),
                              backgroundColor:
                                  status ==
                                          "Paid"
                                      ? Colors
                                          .green
                                      : Colors
                                          .red,
                            ),
                          ],
                        ),

                        const Divider(),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Paid Amount",
                            ),

                            Text(
                              "RM ${paidAmount.toStringAsFixed(2)}",
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Outstanding Balance",
                            ),

                            Text(
                              "RM ${remainingAmount.toStringAsFixed(2)}",
                            ),
                          ],
                        ),

                        const Divider(),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Total",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(
                              "RM ${totalFee.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF1976D2),
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
                                      PaymentMethodPage(
                                    studentID:
                                        studentID,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "PAY RM ${remainingAmount.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
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