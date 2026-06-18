import 'package:flutter/material.dart';
import 'PaymentConfirmationPage.dart';

class PaymentMethodPage extends StatefulWidget {

  final String studentID;

  const PaymentMethodPage({
    super.key,
    required this.studentID,
  });

  @override
  State<PaymentMethodPage> createState() =>
      _PaymentMethodPageState();
}

class _PaymentMethodPageState
    extends State<PaymentMethodPage> {

  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),

      appBar: AppBar(
        title: const Text(
          "PAYMENT METHOD",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage(
                'assets/icons/sams_logo.png',
              ),
            ),

            const SizedBox(height: 30),

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
                        "Payment Method",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    DropdownButtonFormField<
                        String>(
                      value:
                          selectedMethod,
                      decoration:
                          const InputDecoration(
                        border:
                            OutlineInputBorder(),
                        hintText:
                            "Select Payment Method",
                      ),
                      items: const [

                        DropdownMenuItem(
                          value:
                              "Maybank2u",
                          child: Text(
                              "Maybank2u"),
                        ),

                        DropdownMenuItem(
                          value:
                              "CIMB Clicks",
                          child: Text(
                              "CIMB Clicks"),
                        ),

                        DropdownMenuItem(
                          value:
                              "Bank Islam",
                          child: Text(
                              "Bank Islam"),
                        ),
                      ],
                      onChanged:
                          (value) {
                        setState(() {
                          selectedMethod =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 20),

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
                        ),
                        onPressed:
                            () {

                          if (selectedMethod ==
                              null) {
                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please select a payment method",
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PaymentConfirmationPage(
                                studentID:
                                    widget.studentID,
                                paymentMethod:
                                    selectedMethod!,
                              ),
                            ),
                          );
                        },
                        child:
                            const Text(
                          "Continue",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}