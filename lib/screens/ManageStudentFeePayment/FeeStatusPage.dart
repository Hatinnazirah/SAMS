import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PaymentDetailsPage.dart';

class FeeStatusPage extends StatelessWidget {
  final String studentID;

  const FeeStatusPage({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "FEE PAYMENT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
                    fee['TotalFee']
                        .toString(),
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

          return Padding(
            padding:
                const EdgeInsets.all(
                    20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      const AssetImage(
                    'assets/icons/sams_logo.png',
                  ),
                ),

                const SizedBox(
                    height: 25),

                Card(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets
                            .all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        const Text(
                          "Total Fee",
                          style:
                              TextStyle(
                            color:
                                Colors
                                    .grey,
                            fontSize:
                                18,
                          ),
                        ),

                        const SizedBox(
                            height:
                                10),

                        Text(
                          "RM ${totalFee.toStringAsFixed(2)}",
                          style:
                              const TextStyle(
                            fontSize:
                                35,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                            height:
                                15),

                        ClipRRect(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      10),
                          child:
                              LinearProgressIndicator(
                            value:
                                progress,
                            minHeight:
                                10,
                            color: Colors
                                .green,
                          ),
                        ),

                        const SizedBox(
                            height:
                                10),

                        Text(
                          "Balance : RM ${remainingAmount.toStringAsFixed(2)}",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                            height:
                                15),

                        SizedBox(
                          width: double
                              .infinity,
                          child:
                              ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF1976D2),
                              foregroundColor:
                                  Colors
                                      .white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    15,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                            onPressed:
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (
                                        context,
                                      ) =>
                                          PaymentDetailsPage(
                                    studentID:
                                        studentID,
                                  ),
                                ),
                              );
                            },
                            child:
                                const Text(
                              "Pay Tuition Fee",
                              style:
                                  TextStyle(
                                fontSize:
                                    16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height:
                                10),

                        Text(
                          "Due Date : ${fee['DueDate'] ?? '-'}",
                          style:
                              const TextStyle(
                            color:
                                Colors
                                    .grey,
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