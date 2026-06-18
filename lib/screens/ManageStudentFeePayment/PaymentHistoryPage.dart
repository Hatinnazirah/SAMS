import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryPage extends StatelessWidget {

  final String studentID;

  const PaymentHistoryPage({
    super.key,
    required this.studentID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAYMENT HISTORY",
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
                "No Payment Record Found",
              ),
            );
          }

          final payments =
              snapshot.data!.docs;

          final latestPayment =
              payments.first.data()
                  as Map<String, dynamic>;

          String paymentID =
              latestPayment['PaymentID'] ?? '';

          String paymentMethod =
              latestPayment['PaymentMethod'] ?? '';

          String paymentStatus =
              latestPayment['PaymentStatus'] ?? '';

          var amount =
              latestPayment['Amount'] ?? 0;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50,
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
                        BorderRadius.circular(
                            15),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: const Text(
                      "Latest Payment",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Payment ID : $paymentID\n"
                      "Paid via $paymentMethod",
                    ),
                    trailing: Text(
                      "RM$amount",
                      style:
                          const TextStyle(
                        color:
                            Colors.green,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 15),

                Card(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                  child: ListTile(
                    leading: Icon(
                      paymentStatus ==
                              "Success"
                          ? Icons
                              .check_circle
                          : Icons.cancel,
                      color:
                          paymentStatus ==
                                  "Success"
                              ? Colors
                                  .green
                              : Colors
                                  .red,
                    ),
                    title: const Text(
                      "Payment Status",
                    ),
                    subtitle: Text(
                      paymentStatus,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 15),

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
                            15),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        const Text(
                          "Payment Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Text(
                          "Student ID : $studentID",
                        ),

                        Text(
                          "Amount Paid : RM$amount",
                        ),

                        Text(
                          "Payment Method : $paymentMethod",
                        ),

                        Text(
                          "Payment ID : $paymentID",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                const Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    "Transaction History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      payments.length,
                  itemBuilder:
                      (context, index) {

                    final payment =
                        payments[index]
                                .data()
                            as Map<String,
                                dynamic>;

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.payment,
                        ),
                        title: Text(
                          payment['PaymentID'] ??
                              '',
                        ),
                        subtitle: Text(
                          payment['PaymentMethod'] ??
                              '',
                        ),
                        trailing: Text(
                          "RM${payment['Amount']}",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}