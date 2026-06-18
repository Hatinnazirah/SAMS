import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordPaymentPage extends StatelessWidget {
  final String studentID;

  const RecordPaymentPage({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "TRANSACTION STATEMENT",
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
            .collection('Payment')
            .where('StudentID', isEqualTo: studentID)
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
                "No transaction record found",
              ),
            );
          }

          final payments = snapshot.data!.docs;

          double totalPaid = 0;

          for (var payment in payments) {
            totalPaid +=
                double.tryParse(
                      payment['Amount']
                          .toString(),
                    ) ??
                    0;
          }

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(15),
                    child: Column(
                      children: [

                        const Icon(
                          Icons.receipt_long,
                          size: 60,
                          color: Colors.blue,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const Text(
                          "PAYMENT TRANSACTION STATEMENT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const Divider(),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            const Text(
                              "Student ID",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(studentID),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: ListView.builder(
                    itemCount: payments.length,
                    itemBuilder:
                        (context, index) {

                      final payment =
                          payments[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(15),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            15,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              Text(
                                payment[
                                        'PaymentID'] ??
                                    '',
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Reference No : ${payment['PaymentID'] ?? ''}",
                              ),

                              Text(
                                "Amount Paid : RM${payment['Amount'] ?? 0}",
                              ),

                              Text(
                                "Payment Method : ${payment['PaymentMethod'] ?? ''}",
                              ),

                              Text(
                                "Payment Status : ${payment['PaymentStatus'] ?? ''}",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Card(
                  color:
                      Colors.green.shade50,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      15,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [

                        const Text(
                          "TOTAL PAID",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          "RM${totalPaid.toStringAsFixed(2)}",
                          style:
                              const TextStyle(
                            color:
                                Colors.green,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Statement generated successfully",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.download,
                    ),
                    label: const Text(
                      "DOWNLOAD STATEMENT",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                      foregroundColor:
                          Colors.white,
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