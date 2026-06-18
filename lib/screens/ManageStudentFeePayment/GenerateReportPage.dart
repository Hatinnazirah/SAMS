import '../../controllers/ManageCurriculumCoCurriculumActivities/ManageStudentFeePayment/PaymentController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DownloadReportPage.dart';

class GenerateReportPage extends StatefulWidget {
  const GenerateReportPage({super.key});

  @override
  State<GenerateReportPage> createState() =>
      _GenerateReportPageState();
}

class _GenerateReportPageState
    extends State<GenerateReportPage> {

  final PaymentController _paymentController =
      PaymentController();

  String? selectedSemester;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAYMENT REPORT",
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
                "No Report Data Found",
              ),
            );
          }

          List<QueryDocumentSnapshot> fees =
              snapshot.data!.docs;

          if (selectedSemester != null) {
            fees = fees.where((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;

              return data['Semester'] ==
                  selectedSemester;
            }).toList();
          }

          if (selectedStatus != null) {
            fees = fees.where((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;

              return data['FeeStatus'] ==
                  selectedStatus;
            }).toList();
          }

          int totalStudents =
              fees.length;

          double totalPaid = 0;
          double totalUnpaid = 0;

          for (var doc in fees) {

            final data =
                doc.data()
                    as Map<String, dynamic>;

            double totalFee =
                double.tryParse(
                      data['TotalFee']
                          .toString(),
                    ) ??
                    0;

            double remaining =
                double.tryParse(
                      data['RemainingAmount']
                          .toString(),
                    ) ??
                    0;

            totalPaid +=
                (totalFee - remaining);

            totalUnpaid +=
                remaining;
          }

          return Padding(
            padding:
                const EdgeInsets.all(20),
            child: Card(
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

                    DropdownButtonFormField<
                        String>(
                      value:
                          selectedSemester,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Semester",
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(
                          value:
                              "Semester 1",
                          child: Text(
                              "Semester 1"),
                        ),

                        DropdownMenuItem(
                          value:
                              "Semester 2",
                          child: Text(
                              "Semester 2"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSemester =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 15),

                    DropdownButtonFormField<
                        String>(
                      value:
                          selectedStatus,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Status",
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "Paid",
                          child:
                              Text("Paid"),
                        ),

                        DropdownMenuItem(
                          value: "Unpaid",
                          child:
                              Text("Unpaid"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 20),

                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets
                              .all(15),
                      decoration:
                          BoxDecoration(
                        border: Border.all(
                          color: Colors
                              .grey.shade300,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                                    10),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          Text(
                            "TOTAL STUDENTS: $totalStudents",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 5),

                          Text(
                            "Total Paid : RM${totalPaid.toStringAsFixed(2)}",
                          ),

                          Text(
                            "Total Unpaid : RM${totalUnpaid.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    Expanded(
                      child:
                          ListView.builder(
                        itemCount:
                            fees.length,
                        itemBuilder:
                            (context,
                                index) {

                          final data =
                              fees[index]
                                      .data()
                                  as Map<
                                      String,
                                      dynamic>;

                          return ListTile(
                            title: Text(
                              data['StudentID'] ??
                                  '',
                            ),
                            trailing:
                                Text(
                              data['FeeStatus'] ??
                                  '',
                            ),
                          );
                        },
                      ),
                    ),

                    Row(
                      children: [

                        Expanded(
                          child:
                              ElevatedButton(
                            onPressed:
                                () {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                      Text(
                                    "Report Generated Successfully",
                                  ),
                                ),
                              );
                            },
                            child:
                                const Text(
                              "Generate Report",
                            ),
                          ),
                        ),

                        const SizedBox(
                            width: 10),

                        Expanded(
                          child:
                              ElevatedButton(
                            onPressed:
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          const DownloadReportPage(),
                                ),
                              );
                            },
                            child:
                                const Text(
                              "Download PDF",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 10),

                    Align(
                      alignment:
                          Alignment
                              .centerLeft,
                      child:
                          TextButton.icon(
                        onPressed:
                            () {
                          Navigator.pop(
                              context);
                        },
                        icon: const Icon(
                          Icons
                              .arrow_back,
                        ),
                        label:
                            const Text(
                          "Back",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}