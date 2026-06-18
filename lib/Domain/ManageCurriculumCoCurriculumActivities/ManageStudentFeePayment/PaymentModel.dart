class PaymentModel {
  final String paymentID;
  final String studentID;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String referenceNo;

  PaymentModel({
    required this.paymentID,
    required this.studentID,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.referenceNo,
  });

  factory PaymentModel.fromFirestore(
      Map<String, dynamic> data) {
    return PaymentModel(
      paymentID: data['PaymentID'] ?? '',
      studentID: data['StudentID'] ?? '',
      amount:
          (data['Amount'] ?? 0)
              .toDouble(),
      paymentMethod:
          data['PaymentMethod'] ?? '',
      paymentStatus:
          data['PaymentStatus'] ?? '',
      referenceNo:
          data['ReferenceNo'] ?? '',
    );
  }
}