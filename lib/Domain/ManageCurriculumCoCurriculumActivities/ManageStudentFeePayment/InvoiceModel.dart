class InvoiceModel {
  final String invoiceID;
  final String studentID;
  final String paymentID;
  final double totalAmount;
  final String remarks;

  InvoiceModel({
    required this.invoiceID,
    required this.studentID,
    required this.paymentID,
    required this.totalAmount,
    required this.remarks,
  });

  factory InvoiceModel.fromFirestore(
      Map<String, dynamic> data) {
    return InvoiceModel(
      invoiceID: data['InvoiceID'] ?? '',
      studentID: data['StudentID'] ?? '',
      paymentID: data['PaymentID'] ?? '',
      totalAmount:
          (data['TotalAmount'] ?? 0)
              .toDouble(),
      remarks: data['Remarks'] ?? '',
    );
  }
}