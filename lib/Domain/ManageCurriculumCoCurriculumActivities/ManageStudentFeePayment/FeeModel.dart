class FeeModel {
  final String feeID;
  final String studentID;
  final String feeStatus;
  final double totalFee;
  final double paidAmount;
  final double remainingAmount;
  final String dueDate;
  final String semester;

  FeeModel({
    required this.feeID,
    required this.studentID,
    required this.feeStatus,
    required this.totalFee,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.semester,
  });

  factory FeeModel.fromFirestore(Map<String, dynamic> data) {
    return FeeModel(
      feeID: data['FeeID'] ?? '',
      studentID: data['StudentID'] ?? '',
      feeStatus: data['FeeStatus'] ?? '',
      totalFee: (data['TotalFee'] ?? 0).toDouble(),
      paidAmount: (data['PaidAmount'] ?? 0).toDouble(),
      remainingAmount: (data['RemainingAmount'] ?? 0).toDouble(),
      dueDate: data['DueDate'] ?? '',
      semester: data['Semester'] ?? '',
    );
  }
}