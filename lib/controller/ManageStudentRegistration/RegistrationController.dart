import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';

class RegistrationController {
  // Simulated database - In real app, this would connect to Firestore/API
  final List<SubjectModel> _availableSubjects = [];
  final List<RegistrationModel> _registrations = [];

  // Singleton pattern
  static final RegistrationController _instance = RegistrationController._internal();
  factory RegistrationController() => _instance;
  RegistrationController._internal();

  // Getters
  List<SubjectModel> get availableSubjects => _availableSubjects;
  List<RegistrationModel> get registrations => _registrations;

  // Get available subjects (CurrentEnrolled < MaxCapacity)
  Future<List<SubjectModel>> getAvailableSubjects() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _availableSubjects.where((s) => s.currentEnrolled < s.maxCapacity).toList();
  }

  // Get registered subjects for a student
  Future<List<RegistrationModel>> getRegisteredSubjects(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registrations
        .where((r) => r.studentId == studentId)
        .toList();
  }

  // Add subject with validations
  Future<String> addSubject(String studentId, String subjectId, {String? lectureSection, String? labSection}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Get the subject
    SubjectModel? subject;
    try {
      subject = _availableSubjects.firstWhere((s) => s.subjectId == subjectId);
    } catch (_) {
      return 'Subject not found';
    }

    // Validate credit hours (max 21)
    final approvedRegistrations = _registrations.where(
      (r) => r.studentId == studentId && r.status == RegistrationStatus.approve,
    ).toList();

    int currentTotal = 0;
    for (var reg in approvedRegistrations) {
      final regSubject = _availableSubjects.firstWhere(
        (s) => s.subjectId == reg.subjectId,
      );
      currentTotal += regSubject.creditHours;
    }

    if (currentTotal + subject.creditHours > 21) {
      return 'Exceeds maximum credit hours (21)';
    }

    // Check for duplicate registration (same subject + same lab section)
    final exists = _registrations.any((r) => 
      r.studentId == studentId && 
      r.subjectId == subjectId && 
      r.labSection == labSection
    );
    if (exists) {
      return 'Subject already registered for this lab section';
    }

    // Check for schedule clash
    final studentRegistrations = _registrations.where(
      (r) => r.studentId == studentId && 
             (r.status == RegistrationStatus.pending || 
              r.status == RegistrationStatus.approve),
    ).toList();

    for (var reg in studentRegistrations) {
      SubjectModel? regSubject;
      try {
        regSubject = _availableSubjects.firstWhere((s) => s.subjectId == reg.subjectId);
      } catch (_) {
        continue; // If subject not found in available list, skip check
      }

      if (regSubject.scheduleDay == subject.scheduleDay) {
        final regStart = _parseTime(regSubject.scheduleStartTime);
        final regEnd = _parseTime(regSubject.scheduleEndTime);
        final newStart = _parseTime(subject.scheduleStartTime);
        final newEnd = _parseTime(subject.scheduleEndTime);

        if (newStart.isBefore(regEnd) && newEnd.isAfter(regStart)) {
          return 'Schedule clashes with existing subject';
        }
      }
    }

    // Create registration
    final newRegistration = RegistrationModel(
      registrationId: _generateId(),
      studentId: studentId,
      subjectId: subjectId,
      studentName: 'Hatin Nazirah', // Should come from student data
      matricId: 'CB23048', // Should come from student data
      subjectCode: subject.subjectCode,
      subjectName: subject.subjectName,
      creditHours: subject.creditHours,
      status: RegistrationStatus.pending,
      registrationDate: DateTime.now(),
      lectureSection: lectureSection,
      labSection: labSection,
    );

    _registrations.add(newRegistration);
    return 'success';
  }

  // Drop subject
  Future<String> dropSubject(String registrationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _registrations.removeWhere((r) => r.registrationId == registrationId);
    return 'success';
  }

  // Update registration status (Approve/Reject)
  Future<String> updateRegistrationStatus(
    String registrationId,
    RegistrationStatus status,
    String? reason,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _registrations.indexWhere((r) => r.registrationId == registrationId);
    if (index == -1) return 'Registration not found';

    final oldRegistration = _registrations[index];
    
    final updatedRegistration = RegistrationModel(
      registrationId: oldRegistration.registrationId,
      studentId: oldRegistration.studentId,
      subjectId: oldRegistration.subjectId,
      studentName: oldRegistration.studentName,
      matricId: oldRegistration.matricId,
      subjectCode: oldRegistration.subjectCode,
      subjectName: oldRegistration.subjectName,
      creditHours: oldRegistration.creditHours,
      status: status,
      registrationDate: oldRegistration.registrationDate,
      rejectionReason: reason,
      approvedDate: status == RegistrationStatus.approve ? DateTime.now() : null,
      rejectedDate: status == RegistrationStatus.reject ? DateTime.now() : null,
      lectureSection: oldRegistration.lectureSection,
      labSection: oldRegistration.labSection,
    );

    _registrations[index] = updatedRegistration;

    // Update subject current enrolled if approved
    if (status == RegistrationStatus.approve) {
      final subjectIndex = _availableSubjects.indexWhere(
        (s) => s.subjectId == oldRegistration.subjectId,
      );
      if (subjectIndex != -1) {
        final subject = _availableSubjects[subjectIndex];
        _availableSubjects[subjectIndex] = SubjectModel(
          subjectId: subject.subjectId,
          subjectCode: subject.subjectCode,
          subjectName: subject.subjectName,
          creditHours: subject.creditHours,
          scheduleDay: subject.scheduleDay,
          scheduleStartTime: subject.scheduleStartTime,
          scheduleEndTime: subject.scheduleEndTime,
          venue: subject.venue,
          facultyOffered: subject.facultyOffered,
          programOffered: subject.programOffered,
          lecturerName: subject.lecturerName,
          maxCapacity: subject.maxCapacity,
          currentEnrolled: subject.currentEnrolled + 1,
        );
      }
    }

    return 'success';
  }

  // Get all student registrations (for Faculty Registrar)
  Future<List<RegistrationModel>> getAllStudentRegistrations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registrations.where((r) => r.status == RegistrationStatus.pending).toList();
  }

  // Get participants for a subject
  Future<List<RegistrationModel>> getSubjectParticipants(String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registrations
        .where((r) => r.subjectId == subjectId && r.status == RegistrationStatus.approve)
        .toList();
  }

  // Helper methods
  String _generateId() {
    return 'REG_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Initialize mock data
  void initMockData() {
    _availableSubjects.clear();
    _availableSubjects.addAll([
      SubjectModel(
        subjectId: 'SUB001',
        subjectCode: 'BCS1033',
        subjectName: 'SOFTWARE ENGINEERING',
        creditHours: 3,
        scheduleDay: 'Monday',
        scheduleStartTime: '10:00',
        scheduleEndTime: '12:00',
        venue: 'DK1',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Ahmad',
        maxCapacity: 40,
        currentEnrolled: 25,
      ),
      SubjectModel(
        subjectId: 'SUB002',
        subjectCode: 'BCI1023',
        subjectName: 'PROGRAMMING TECHNIQUES',
        creditHours: 3,
        scheduleDay: 'Tuesday',
        scheduleStartTime: '14:00',
        scheduleEndTime: '17:00',
        venue: 'DK2',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Siti',
        maxCapacity: 35,
        currentEnrolled: 30,
      ),
      SubjectModel(
        subjectId: 'SUB003',
        subjectCode: 'BCS2023',
        subjectName: 'DATABASE SYSTEMS',
        creditHours: 3,
        scheduleDay: 'Wednesday',
        scheduleStartTime: '10:00',
        scheduleEndTime: '13:00',
        venue: 'Lab 1',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Rizal',
        maxCapacity: 30,
        currentEnrolled: 28,
      ),
      SubjectModel(
        subjectId: 'SUB004',
        subjectCode: 'BCS1133',
        subjectName: 'SYSTEMS ANALYSIS & DESIGN',
        creditHours: 3,
        scheduleDay: 'Friday',
        scheduleStartTime: '10:00',
        scheduleEndTime: '13:00',
        venue: 'Lab 3',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Sara',
        maxCapacity: 50,
        currentEnrolled: 24,
      ),
      SubjectModel(
        subjectId: 'SUB005',
        subjectCode: 'BCS1133',
        subjectName: 'SYSTEMS ANALYSIS & DESIGN',
        creditHours: 3,
        scheduleDay: 'Friday',
        scheduleStartTime: '10:00',
        scheduleEndTime: '13:00',
        venue: 'Lab 3',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Sara',
        maxCapacity: 60,
        currentEnrolled: 25,
      ),
      SubjectModel(
        subjectId: 'SUB006',
        subjectCode: 'BCS2213',
        subjectName: 'FORMAL METHOD',
        creditHours: 3,
        scheduleDay: 'Thursday',
        scheduleStartTime: '10:00',
        scheduleEndTime: '13:00',
        venue: 'Lab 5',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Amira',
        maxCapacity: 40,
        currentEnrolled: 25,
      ),
       SubjectModel(
        subjectId: 'SUB007',
        subjectCode: 'BCS3233',
        subjectName: 'SOFTWARE TESTING',
        creditHours: 3,
        scheduleDay: 'Monday',
        scheduleStartTime: '14:00',
        scheduleEndTime: '16:00',
        venue: 'Lab 10',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Kelvin',
        maxCapacity: 50,
        currentEnrolled: 38,
      ),
      SubjectModel(
        subjectId: 'SUB008',
        subjectCode: 'BCS3133',
        subjectName: 'SOFTWARE ENGINEERING PRACTICES',
        creditHours: 3,
        scheduleDay: 'Tuesday',
        scheduleStartTime: '08:00',
        scheduleEndTime: '10:00',
        venue: 'Lab 20',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Mun',
        maxCapacity: 60,
        currentEnrolled: 28,
      ),
      SubjectModel(
        subjectId: 'SUB009',
        subjectCode: 'BCS3143	',
        subjectName: 'SOFTWARE PROJECT MANAGEMENT',
        creditHours: 3,
        scheduleDay: 'Wednesday',
        scheduleStartTime: '08:00',
        scheduleEndTime: '10:00',
        venue: 'Lab 6',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Ken',
        maxCapacity: 60,
        currentEnrolled: 40,
      ),
       SubjectModel(
        subjectId: 'SUB010',
        subjectCode: 'BCS3153	',
        subjectName: 'SOFTWARE EVOLUTION & MAINTENANCE',
        creditHours: 3,
        scheduleDay: 'Friday',
        scheduleStartTime: '08:00',
        scheduleEndTime: '10:00',
        venue: 'Lab 6',
        facultyOffered: 'FK',
        programOffered: 'BCS',
        lecturerName: 'Dr. Ken',
        maxCapacity: 60,
        currentEnrolled: 34,
      ),
    ]);
  }
}