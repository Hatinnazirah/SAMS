import 'package:flutter/material.dart';

enum RegistrationStatus { pending, approve, reject }

class RegistrationModel {
  final String registrationId;
  final String studentId;
  final String subjectId;
  final String studentName;
  final String matricId;
  final String subjectCode;
  final String subjectName;
  final int creditHours;
  final RegistrationStatus status;
  final DateTime registrationDate;
  final String? rejectionReason;
  final DateTime? approvedDate;
  final DateTime? rejectedDate;
  final String? lectureSection;
  final String? labSection;

  RegistrationModel({
    required this.registrationId,
    required this.studentId,
    required this.subjectId,
    required this.studentName,
    required this.matricId,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
    required this.status,
    required this.registrationDate,
    this.rejectionReason,
    this.approvedDate,
    this.rejectedDate,
    this.lectureSection,
    this.labSection,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      registrationId: json['RegistrationID'] as String,
      studentId: json['StudentID'] as String,
      subjectId: json['SubjectID'] as String,
      studentName: json['StudentName'] as String,
      matricId: json['MatricID'] as String,
      subjectCode: json['SubjectCode'] as String,
      subjectName: json['SubjectName'] as String,
      creditHours: json['CreditHours'] as int,
      status: _parseStatus(json['RegistrationStatus'] as String),
      registrationDate: DateTime.parse(json['RegistrationDate'] as String),
      rejectionReason: json['RejectionReason'] as String?,
      approvedDate: json['ApprovedDate'] != null
          ? DateTime.parse(json['ApprovedDate'] as String)
          : null,
      rejectedDate: json['RejectedDate'] != null
          ? DateTime.parse(json['RejectedDate'] as String)
          : null,
      lectureSection: json['LectureSection'] as String?,
      labSection: json['LabSection'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RegistrationID': registrationId,
      'StudentID': studentId,
      'SubjectID': subjectId,
      'StudentName': studentName,
      'MatricID': matricId,
      'SubjectCode': subjectCode,
      'SubjectName': subjectName,
      'CreditHours': creditHours,
      'RegistrationStatus': status.name,
      'RegistrationDate': registrationDate.toIso8601String(),
      'RejectionReason': rejectionReason,
      'ApprovedDate': approvedDate?.toIso8601String(),
      'RejectedDate': rejectedDate?.toIso8601String(),
      'LectureSection': lectureSection,
      'LabSection': labSection,
    };
  }

  static RegistrationStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approve':
        return RegistrationStatus.approve;
      case 'reject':
        return RegistrationStatus.reject;
      default:
        return RegistrationStatus.pending;
    }
  }

  Color getStatusBadgeColor() {
    switch (status) {
      case RegistrationStatus.pending:
        return Colors.orange;
      case RegistrationStatus.approve:
        return Colors.green;
      case RegistrationStatus.reject:
        return Colors.red;
    }
  }

  String getStatusDisplay() {
    switch (status) {
      case RegistrationStatus.pending:
        return "Pending";
      case RegistrationStatus.approve:
        return "Approved";
      case RegistrationStatus.reject:
        return "Rejected";
    }
  }
}

class SubjectModel {
  final String subjectId;
  final String subjectCode;
  final String subjectName;
  final int creditHours;
  final String scheduleDay;
  final String scheduleStartTime;
  final String scheduleEndTime;
  final String venue;
  final String facultyOffered;
  final String programOffered;
  final String lecturerName;
  final int maxCapacity;
  final int currentEnrolled;

  SubjectModel({
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
    required this.scheduleDay,
    required this.scheduleStartTime,
    required this.scheduleEndTime,
    required this.venue,
    required this.facultyOffered,
    required this.programOffered,
    required this.lecturerName,
    required this.maxCapacity,
    required this.currentEnrolled,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['SubjectID'] as String,
      subjectCode: json['SubjectCode'] as String,
      subjectName: json['SubjectName'] as String,
      creditHours: json['CreditHours'] as int,
      scheduleDay: json['ScheduleDay'] as String,
      scheduleStartTime: json['ScheduleStartTime'] as String,
      scheduleEndTime: json['ScheduleEndTime'] as String,
      venue: json['Venue'] as String,
      facultyOffered: json['FacultyOffered'] as String,
      programOffered: json['ProgramOffered'] as String,
      lecturerName: json['LecturerName'] as String,
      maxCapacity: json['MaxCapacity'] as int,
      currentEnrolled: json['CurrentEnrolled'] as int,
    );
  }

  int get availableSlots => maxCapacity - currentEnrolled;
  String get scheduleDisplay =>
      "$scheduleDay $scheduleStartTime - $scheduleEndTime";
}

class StudentModel {
  final String studentId;
  final String userId;
  final String studentName;
  final String matricId;
  final String studentProgram;
  final int semester;
  final String studentFaculty;

  StudentModel({
    required this.studentId,
    required this.userId,
    required this.studentName,
    required this.matricId,
    required this.studentProgram,
    required this.semester,
    required this.studentFaculty,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['StudentID'] as String,
      userId: json['UserID'] as String,
      studentName: json['StudentName'] as String,
      matricId: json['MatricID'] as String,
      studentProgram: json['StudentProgram'] as String,
      semester: json['Semester'] as int,
      studentFaculty: json['StudentFaculty'] as String,
    );
  }
}
