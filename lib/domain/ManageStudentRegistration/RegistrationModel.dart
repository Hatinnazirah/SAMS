import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // ============ FIREBASE METHODS ============

  // Create from Firestore document
  factory RegistrationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return RegistrationModel(
      registrationId: doc.id,
      studentId: data['StudentId'] ?? '',
      subjectId: data['SubjectId'] ?? '',
      studentName: data['StudentName'] ?? '',
      matricId: data['MatricId'] ?? '',
      subjectCode: data['SubjectCode'] ?? '',
      subjectName: data['SubjectName'] ?? '',
      creditHours: _toInt(data['CreditHours']),
      status: _stringToStatus(data['Status'] ?? 'pending'),
      registrationDate: (data['RegistrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rejectionReason: data['RejectionReason'],
      approvedDate: (data['ApprovedDate'] as Timestamp?)?.toDate(),
      rejectedDate: (data['RejectedDate'] as Timestamp?)?.toDate(),
      lectureSection: data['LectureSection'] ?? 'N/A',
      labSection: data['LabSection'] ?? 'N/A',
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'StudentId': studentId,
      'SubjectId': subjectId,
      'StudentName': studentName,
      'MatricId': matricId,
      'SubjectCode': subjectCode,
      'SubjectName': subjectName,
      'CreditHours': creditHours,
      'Status': status.name,
      'RegistrationDate': FieldValue.serverTimestamp(),
      'RejectionReason': rejectionReason,
      'ApprovedDate': approvedDate != null ? Timestamp.fromDate(approvedDate!) : null,
      'RejectedDate': rejectedDate != null ? Timestamp.fromDate(rejectedDate!) : null,
      'LectureSection': lectureSection,
      'LabSection': labSection,
    };
  }

  // ============ HELPER METHODS ============

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static RegistrationStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return RegistrationStatus.approve;
      case 'rejected':
        return RegistrationStatus.reject;
      default:
        return RegistrationStatus.pending;
    }
  }

  // ============ EXISTING METHODS ============

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

// ============ SUBJECT MODEL WITH FIREBASE ============

class SubjectModel {
  final String subjectId;
  final String subjectCode;
  final String subjectName;
  final int creditHours;
  final List<String> scheduleDay;         // ← NOW ARRAY
  final List<String> scheduleStartTime;   // ← NOW ARRAY
  final List<String> scheduleEndTime;     // ← NOW ARRAY
  final String venue;
  final String facultyOffered;
  final String programOffered;
  final String lecturerName;
  final int maxCapacity;
  final int currentEnrolled;
  final List<String> lectureSections;
  final List<String> labSections;

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
    this.lectureSections = const ['01', '02'],
    this.labSections = const ['01A', '01B'],
  });

  // ============ FIREBASE METHODS ============

  // Helper to convert Firebase data to List<String>
  static List<String> _toList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [value.toString()];
  }

  // Helper to convert to int
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  // Create from Firestore document
  factory SubjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SubjectModel(
      subjectId: data['SubjectID'] ?? doc.id,
      subjectCode: data['SubjectCode'] ?? '',
      subjectName: data['SubjectName'] ?? '',
      creditHours: _toInt(data['CreditHours']),
      scheduleDay: _toList(data['ScheduleDay']),
      scheduleStartTime: _toList(data['ScheduleStartTime']),
      scheduleEndTime: _toList(data['ScheduleEndTime']),
      venue: data['Venue'] ?? '',
      facultyOffered: data['FacultyOffered'] ?? '',
      programOffered: data['ProgramOffered'] ?? '',
      lecturerName: data['LecturerName'] ?? '',
      maxCapacity: _toInt(data['MaxCapacity']),
      currentEnrolled: _toInt(data['CurrentEnrolled']),
      lectureSections: _toList(data['LectureSection']),
      labSections: _toList(data['LabSection']),
    );
  }

  // ============ EXISTING METHODS ============

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['SubjectID'] as String,
      subjectCode: json['SubjectCode'] as String,
      subjectName: json['SubjectName'] as String,
      creditHours: json['CreditHours'] as int,
      scheduleDay: (json['ScheduleDay'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      scheduleStartTime: (json['ScheduleStartTime'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      scheduleEndTime: (json['ScheduleEndTime'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      venue: json['Venue'] as String,
      facultyOffered: json['FacultyOffered'] as String,
      programOffered: json['ProgramOffered'] as String,
      lecturerName: json['LecturerName'] as String,
      maxCapacity: json['MaxCapacity'] as int,
      currentEnrolled: json['CurrentEnrolled'] as int,
      lectureSections: (json['LectureSection'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['01', '02'],
      labSections: (json['LabSection'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['01A', '01B'],
    );
  }

  // Helper to get first element of schedule arrays
  String get firstScheduleDay => scheduleDay.isNotEmpty ? scheduleDay[0] : 'N/A';
  String get firstScheduleStartTime => scheduleStartTime.isNotEmpty ? scheduleStartTime[0] : 'N/A';
  String get firstScheduleEndTime => scheduleEndTime.isNotEmpty ? scheduleEndTime[0] : 'N/A';

  // Get schedule for a specific index
  String getScheduleDay(int index) => scheduleDay.length > index ? scheduleDay[index] : 'N/A';
  String getScheduleStartTime(int index) => scheduleStartTime.length > index ? scheduleStartTime[index] : 'N/A';
  String getScheduleEndTime(int index) => scheduleEndTime.length > index ? scheduleEndTime[index] : 'N/A';

  int get availableSlots => maxCapacity - currentEnrolled;
  
  String get scheduleDisplay {
    if (scheduleDay.isEmpty) return 'N/A';
    final day = scheduleDay[0];
    final start = scheduleStartTime.isNotEmpty ? scheduleStartTime[0] : 'N/A';
    final end = scheduleEndTime.isNotEmpty ? scheduleEndTime[0] : 'N/A';
    return "$day $start - $end";
  }
}

// ============ STUDENT MODEL ============

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

  // Firebase method
  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      studentId: data['StudentID'] ?? doc.id,
      userId: data['UserID'] ?? '',
      studentName: data['StudentName'] ?? '',
      matricId: data['MatricID'] ?? '',
      studentProgram: data['StudentProgram'] ?? '',
      semester: _toInt(data['Semester']),
      studentFaculty: data['StudentFaculty'] ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}