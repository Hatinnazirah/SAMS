import 'package:flutter/material.dart';

class DownloadReportPage extends StatelessWidget {
  const DownloadReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "DOWNLOAD REPORT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 90,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Report Generated Successfully",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Report Name",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Student_Fee_Payment_Report.pdf",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.download,
                    ),
                    label: const Text(
                      "Download PDF",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                      foregroundColor:
                          Colors.white,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "PDF downloaded successfully",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
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