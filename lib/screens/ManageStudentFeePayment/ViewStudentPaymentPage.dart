import '../../controllers/ManageCurriculumCoCurriculumActivities/ManageStudentFeePayment/PaymentController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PaymentDetailsAdminPage.dart';

class ViewStudentPaymentPage extends StatefulWidget {
  const ViewStudentPaymentPage({super.key});

  @override
  State<ViewStudentPaymentPage> createState() =>
      _ViewStudentPaymentPageState();
}

class _ViewStudentPaymentPageState
    extends State<ViewStudentPaymentPage> {

  final PaymentController _paymentController =
      PaymentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "STUDENT FEE PAYMENT",
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
        stream: _paymentController.getFeeStream(),
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

          final fees = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: fees.length,
            itemBuilder: (context, index) {

              final fee =
                  fees[index].data()
                      as Map<String, dynamic>;

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 15,
                ),
                child: _studentCard(
                  fee['StudentID'] ?? '',
                  fee['FeeStatus'] ?? '',
                  "RM ${fee['RemainingAmount'] ?? 0}",
                  context,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _studentCard(
    String studentID,
    String status,
    String amount,
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              studentID,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Status: $status",
            ),

            if (status == "Unpaid")
              Text(
                "Amount: $amount",
              ),

            const SizedBox(height: 10),

            Row(
              children: [

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PaymentDetailsAdminPage(
                          studentID:
                              studentID,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.amber,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "Notification sent to $studentID",
                        ),
                      ),
                    );
                  },
                  child:
                      const Text("Notify"),
                ),

                const SizedBox(width: 5),

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "$studentID registration restricted",
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Restrict",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}