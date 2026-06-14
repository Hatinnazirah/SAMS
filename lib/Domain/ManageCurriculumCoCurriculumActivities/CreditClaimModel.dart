class CreditClaimModel {
  String ClaimID;
  String StudentID;
  String ModuleID;
  int CreditsClaimed;
  DateTime ClaimDate;
  String Status;

  CreditClaimModel({
    required this.ClaimID,
    required this.StudentID,
    required this.ModuleID,
    required this.CreditsClaimed,
    required this.ClaimDate,
    required this.Status,
  });

  Map<String, dynamic> toJson() {
    return {
      'ClaimID': ClaimID,
      'StudentID': StudentID,
      'ModuleID': ModuleID,
      'CreditsClaimed': CreditsClaimed,
      'ClaimDate': ClaimDate,
      'Status': Status,
    };
  }

  factory CreditClaimModel.fromJson(Map<String, dynamic> json) {
    return CreditClaimModel(
      ClaimID: json['ClaimID'],
      StudentID: json['StudentID'],
      ModuleID: json['ModuleID'],
      CreditsClaimed: json['CreditsClaimed'],
      ClaimDate: (json['ClaimDate'] as dynamic).toDate(),
      Status: json['Status'],
    );
  }

  String getStatusBadgeColor() {
    if (Status == 'approve') return 'green';
    if (Status == 'reject') return 'red';
    return 'gray';
  }

  String getStatusDisplay() {
    if (Status == 'approve') return "✓ Approved";
    if (Status == 'reject') return "✗ Rejected";
    return Status;
  }
}