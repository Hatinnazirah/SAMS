class ActivityModel {
  String SubmissionID;
  String StudentID;
  String ModuleID;
  String ActivityName;
  String DocumentURL;
  DateTime SubmissionDate;
  int? Score;
  String? GradedBy;
  DateTime? GradedDate;
  String Status;

  ActivityModel({
    required this.SubmissionID,
    required this.StudentID,
    required this.ModuleID,
    required this.ActivityName,
    required this.DocumentURL,
    required this.SubmissionDate,
    this.Score,
    this.GradedBy,
    this.GradedDate,
    required this.Status,
  });

  Map<String, dynamic> toJson() {
    return {
      'SubmissionID': SubmissionID,
      'StudentID': StudentID,
      'ModuleID': ModuleID,
      'ActivityName': ActivityName,
      'DocumentURL': DocumentURL,
      'SubmissionDate': SubmissionDate,
      'Score': Score,
      'GradedBy': GradedBy,
      'GradedDate': GradedDate,
      'Status': Status,
    };
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      SubmissionID: json['SubmissionID'],
      StudentID: json['StudentID'],
      ModuleID: json['ModuleID'],
      ActivityName: json['ActivityName'],
      DocumentURL: json['DocumentURL'],
      SubmissionDate: (json['SubmissionDate'] as dynamic).toDate(),
      Score: json['Score'],
      GradedBy: json['GradedBy'],
      GradedDate: json['GradedDate'] != null ? (json['GradedDate'] as dynamic).toDate() : null,
      Status: json['Status'],
    );
  }

  bool isGraded() {
    return Status == 'graded';
  }

  String getScoreDisplay() {
    if (isGraded() && Score != null) {
      return "$Score/100";
    }
    return "Not graded yet";
  }
}