import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_app/domain/ManageStudentRegistration/RegistrationModel.dart';

class RegistrationController {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local caches
  final List<SubjectModel> _availableSubjects = [];
  final List<RegistrationModel> _registrations = [];

  // Singleton pattern
  static final RegistrationController _instance = RegistrationController._internal();
  factory RegistrationController() => _instance;
  RegistrationController._internal();

  // Getters
  List<SubjectModel> get availableSubjects => _availableSubjects;
  List<RegistrationModel> get registrations => _registrations;

  // ============ HELPER METHODS ============

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  List<String> _arrayToList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  String _statusToString(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.approve:
        return 'approved';
      case RegistrationStatus.reject:
        return 'rejected';
      default:
        return 'pending';
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  RegistrationStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return RegistrationStatus.approve;
      case 'rejected':
        return RegistrationStatus.reject;
      default:
        return RegistrationStatus.pending;
    }
  }

  // ============ SUBJECT METHODS (FROM FIREBASE) ============

  // ✅ Load subjects from Firebase
  Future<void> loadSubjectsFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('Subject').get();
      _availableSubjects.clear();
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        final subject = SubjectModel(
          subjectId: data['SubjectID'] ?? doc.id,
          subjectCode: data['SubjectCode'] ?? '',
          subjectName: data['SubjectName'] ?? '',
          creditHours: _toInt(data['CreditHours']),
          scheduleDay: _arrayToList(data['ScheduleDay']),
          scheduleStartTime: _arrayToList(data['ScheduleStartTime']),
          scheduleEndTime: _arrayToList(data['ScheduleEndTime']),
          venue: data['Venue'] ?? '',
          facultyOffered: data['FacultyOffered'] ?? '',
          programOffered: data['ProgramOffered'] ?? '',
          lecturerName: data['LecturerName'] ?? '',
          maxCapacity: _toInt(data['MaxCapacity']),
          currentEnrolled: _toInt(data['CurrentEnrolled']),
          lectureSections: _arrayToList(data['LectureSection']),
          labSections: _arrayToList(data['LabSection']),
        );
        
        _availableSubjects.add(subject);
      }
      
      print('✅ Loaded ${_availableSubjects.length} subjects from Firebase');
    } catch (e) {
      print('❌ Error loading subjects: $e');
    }
  }

  // ✅ Get available subjects from Firebase
  Future<List<SubjectModel>> getAvailableSubjects() async {
    await loadSubjectsFromFirebase();
    return _availableSubjects.where((s) => s.currentEnrolled < s.maxCapacity).toList();
  }

  // ✅ Get lecture sections from Firebase
  Future<List<String>> getLectureSections(String subjectId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Subject')
          .where('SubjectID', isEqualTo: subjectId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return [];

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> lectureSections = data['LectureSection'] ?? [];
      
      return lectureSections.map((e) => e.toString()).toList();
    } catch (e) {
      print('❌ Error getting lecture sections: $e');
      return [];
    }
  }

  // ✅ Get lab sections from Firebase
  Future<List<String>> getLabSections(String subjectId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Subject')
          .where('SubjectID', isEqualTo: subjectId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return [];

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> labSections = data['LabSection'] ?? [];
      
      return labSections.map((e) => e.toString()).toList();
    } catch (e) {
      print('❌ Error getting lab sections: $e');
      return [];
    }
  }

  // ✅ Get single subject by ID from Firebase
  Future<SubjectModel?> getSubjectById(String subjectId) async {
    try {
      await loadSubjectsFromFirebase();
      try {
        return _availableSubjects.firstWhere((s) => s.subjectId == subjectId);
      } catch (_) {
        return null;
      }
    } catch (e) {
      print('❌ Error getting subject: $e');
      return null;
    }
  }

  // ============ STUDENT METHODS (FROM FIREBASE) ============

  // ✅ Get student data from Firebase - SEARCH BOTH COLLECTIONS
  Future<Map<String, dynamic>?> getStudentData(String studentId) async {
    try {
      print('🔍 Searching for student: $studentId');
      
      // 1️⃣ Try Student collection by StudentID
      QuerySnapshot snapshot = await _firestore
          .collection('Student')
          .where('StudentID', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in Student collection by StudentID');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // 2️⃣ Try Student collection by MatricId
      snapshot = await _firestore
          .collection('Student')
          .where('MatricId', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in Student collection by MatricId');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // 3️⃣ Try User collection by Username
      snapshot = await _firestore
          .collection('User')
          .where('Username', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in User collection by Username');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      // 4️⃣ Try User collection by StudentID
      snapshot = await _firestore
          .collection('User')
          .where('StudentID', isEqualTo: studentId)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        print('✅ Found student in User collection by StudentID');
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      
      print('⚠️ Student not found: $studentId');
      return null;
    } catch (e) {
      print('❌ Error getting student data: $e');
      return null;
    }
  }

  // ✅ Get student program from Firebase
  Future<String> getStudentProgram(String studentId) async {
    try {
      final data = await getStudentData(studentId);
      if (data != null) {
        print('📋 Student data keys: ${data.keys}');
        // Check multiple possible field names
        final program = data['StudentProgram'] ?? 
                        data['Program'] ?? 
                        data['program'] ?? 
                        data['studentProgram'] ?? 
                        data['Major'] ??
                        data['Course'] ??
                        'N/A';
        print('✅ Student Program: $program');
        return program;
      }
      return 'N/A';
    } catch (e) {
      print('❌ Error getting student program: $e');
      return 'N/A';
    }
  }

  // ✅ Get student name from Firebase
  Future<String> getStudentName(String studentId) async {
    try {
      final data = await getStudentData(studentId);
      if (data != null) {
        return data['FullName'] ?? data['StudentName'] ?? data['Name'] ?? studentId;
      }
      return studentId;
    } catch (e) {
      return studentId;
    }
  }

  // ✅ Get student email from Firebase
  Future<String> getStudentEmail(String studentId) async {
    try {
      final data = await getStudentData(studentId);
      if (data != null) {
        return data['Email'] ?? data['email'] ?? 'N/A';
      }
      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

  // ✅ Get student phone from Firebase
  Future<String> getStudentPhone(String studentId) async {
    try {
      final data = await getStudentData(studentId);
      if (data != null) {
        return data['PhoneNumber'] ?? data['Phone'] ?? data['phone'] ?? 'N/A';
      }
      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

  // ✅ Get complete student info from Firebase
  Future<Map<String, String>> getStudentInfo(String studentId) async {
    try {
      final data = await getStudentData(studentId);
      if (data != null) {
        print('✅ Student data found: ${data['StudentName'] ?? data['FullName']}');
        return {
          'name': data['FullName'] ?? data['StudentName'] ?? data['Name'] ?? studentId,
          'email': data['Email'] ?? data['email'] ?? 'N/A',
          'phone': data['PhoneNumber'] ?? data['Phone'] ?? data['phone'] ?? 'N/A',
          'program': data['StudentProgram'] ?? data['Program'] ?? data['program'] ?? data['studentProgram'] ?? 'N/A',
          'matricId': data['MatricId'] ?? data['Username'] ?? data['studentId'] ?? studentId,
        };
      }
      return {
        'name': studentId,
        'email': 'N/A',
        'phone': 'N/A',
        'program': 'N/A',
        'matricId': studentId,
      };
    } catch (e) {
      print('❌ Error getting student info: $e');
      return {
        'name': studentId,
        'email': 'N/A',
        'phone': 'N/A',
        'program': 'N/A',
        'matricId': studentId,
      };
    }
  }

  // ============ REGISTRATION METHODS (FROM FIREBASE) ============

  // ✅ Get registered subjects for a student from Firebase
  Future<List<RegistrationModel>> getRegisteredSubjects(String studentId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Registration')
          .where('StudentId', isEqualTo: studentId)
          .get();

      final List<RegistrationModel> registrations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        final registration = RegistrationModel(
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
        
        registrations.add(registration);
      }

      _registrations.clear();
      _registrations.addAll(registrations);
      
      print('✅ Loaded ${registrations.length} registrations for student: $studentId');
      return registrations;
    } catch (e) {
      print('❌ Error getting registrations: $e');
      return [];
    }
  }

  // ✅ Add subject registration to Firebase
  Future<String> addSubject(
    String studentId, 
    String subjectId, 
    {
      String? lectureSection, 
      String? labSection,
      String? studentName,
      String? matricId,
    }
  ) async {
    try {
      // Load latest subjects from Firebase
      await loadSubjectsFromFirebase();
      
      // Get the subject
      SubjectModel? subject;
      try {
        subject = _availableSubjects.firstWhere((s) => s.subjectId == subjectId);
      } catch (_) {
        return 'Subject not found';
      }

      // Get student's current registrations
      final registrations = await getRegisteredSubjects(studentId);
      
      // Validate credit hours (max 21)
      final approvedRegistrations = registrations.where(
        (r) => r.status == RegistrationStatus.approve,
      ).toList();

      int currentTotal = 0;
      for (var reg in approvedRegistrations) {
        final regSubject = await getSubjectById(reg.subjectId);
        if (regSubject != null) {
          currentTotal += regSubject.creditHours;
        }
      }

      if (currentTotal + subject.creditHours > 21) {
        return 'Exceeds maximum credit hours (21)';
      }

      // Check for duplicate registration
      final exists = registrations.any((r) => 
        r.studentId == studentId && 
        r.subjectId == subjectId && 
        r.labSection == labSection
      );
      if (exists) {
        return 'Subject already registered for this lab section';
      }

      // Check for schedule clash
      final studentRegistrations = registrations.where(
        (r) => r.status == RegistrationStatus.pending || r.status == RegistrationStatus.approve,
      ).toList();

      for (var reg in studentRegistrations) {
        final regSubject = await getSubjectById(reg.subjectId);
        if (regSubject == null) continue;

        for (int i = 0; i < regSubject.scheduleDay.length; i++) {
          final String regDay = regSubject.scheduleDay[i];
          final String regStart = regSubject.scheduleStartTime.length > i ? regSubject.scheduleStartTime[i] : '';
          final String regEnd = regSubject.scheduleEndTime.length > i ? regSubject.scheduleEndTime[i] : '';
          
          for (int j = 0; j < subject.scheduleDay.length; j++) {
            final String newDay = subject.scheduleDay[j];
            final String newStart = subject.scheduleStartTime.length > j ? subject.scheduleStartTime[j] : '';
            final String newEnd = subject.scheduleEndTime.length > j ? subject.scheduleEndTime[j] : '';
            
            if (regDay == newDay) {
              final regStartTime = _parseTime(regStart);
              final regEndTime = _parseTime(regEnd);
              final newStartTime = _parseTime(newStart);
              final newEndTime = _parseTime(newEnd);

              if (newStartTime.isBefore(regEndTime) && newEndTime.isAfter(regStartTime)) {
                return 'Schedule clashes with existing subject';
              }
            }
          }
        }
      }

      // Get student info from Firebase if not provided
      String finalStudentName = studentName ?? 'Unknown Student';
      String finalMatricId = matricId ?? 'N/A';
      
      if (studentName == null || matricId == null) {
        final studentInfo = await getStudentInfo(studentId);
        finalStudentName = studentInfo['name'] ?? studentId;
        finalMatricId = studentInfo['matricId'] ?? studentId;
      }

      // ✅ Create registration in Firebase
      final registrationData = {
        'StudentId': studentId,
        'SubjectId': subjectId,
        'StudentName': finalStudentName,
        'MatricId': finalMatricId,
        'SubjectCode': subject.subjectCode,
        'SubjectName': subject.subjectName,
        'CreditHours': subject.creditHours,
        'Status': 'pending',
        'RegistrationDate': FieldValue.serverTimestamp(),
        'LectureSection': lectureSection ?? 'N/A',
        'LabSection': labSection ?? 'N/A',
        'RejectionReason': null,
        'ApprovedDate': null,
        'RejectedDate': null,
      };

      // ✅ Add to Registration collection in Firebase
      final docRef = await _firestore.collection('Registration').add(registrationData);
      
      print('✅ Registration added for student: $studentId, subject: $subjectId');
      print('   - Registration ID: ${docRef.id}');
      print('   - Student Name: $finalStudentName');
      print('   - Subject: ${subject.subjectCode} ${subject.subjectName}');
      
      return 'success';
    } catch (e) {
      print('❌ Error adding subject: $e');
      return 'Error: $e';
    }
  }

  // ✅ Drop subject from Firebase
  Future<String> dropSubject(String registrationId) async {
    try {
      await _firestore.collection('Registration').doc(registrationId).delete();
      print('✅ Subject dropped: $registrationId');
      return 'success';
    } catch (e) {
      print('❌ Error dropping subject: $e');
      return 'Error: $e';
    }
  }

  // ✅ Update registration status in Firebase
  Future<String> updateRegistrationStatus(
    String registrationId,
    RegistrationStatus status,
    String? reason,
  ) async {
    try {
      final Map<String, dynamic> updateData = {
        'Status': _statusToString(status),
      };

      if (status == RegistrationStatus.approve) {
        updateData['ApprovedDate'] = FieldValue.serverTimestamp();
        updateData['RejectedDate'] = null;
        updateData['RejectionReason'] = null;
      } else if (status == RegistrationStatus.reject) {
        updateData['RejectedDate'] = FieldValue.serverTimestamp();
        updateData['ApprovedDate'] = null;
        if (reason != null && reason.isNotEmpty) {
          updateData['RejectionReason'] = reason;
        }
      } else {
        updateData['ApprovedDate'] = null;
        updateData['RejectedDate'] = null;
        updateData['RejectionReason'] = null;
      }

      await _firestore.collection('Registration').doc(registrationId).update(updateData);

      // Update subject current enrolled if approved
      if (status == RegistrationStatus.approve) {
        final doc = await _firestore.collection('Registration').doc(registrationId).get();
        final data = doc.data() as Map<String, dynamic>;
        final subjectId = data['SubjectId'] ?? '';

        final subjectDoc = await _firestore.collection('Subject').where('SubjectID', isEqualTo: subjectId).get();
        if (subjectDoc.docs.isNotEmpty) {
          final subjectRef = subjectDoc.docs.first.reference;
          await subjectRef.update({
            'CurrentEnrolled': FieldValue.increment(1),
          });
          print('✅ Updated CurrentEnrolled for subject: $subjectId');
        }
      }

      // Update local cache
      final regIndex = _registrations.indexWhere((r) => r.registrationId == registrationId);
      if (regIndex != -1) {
        final oldReg = _registrations[regIndex];
        _registrations[regIndex] = RegistrationModel(
          registrationId: oldReg.registrationId,
          studentId: oldReg.studentId,
          subjectId: oldReg.subjectId,
          studentName: oldReg.studentName,
          matricId: oldReg.matricId,
          subjectCode: oldReg.subjectCode,
          subjectName: oldReg.subjectName,
          creditHours: oldReg.creditHours,
          status: status,
          registrationDate: oldReg.registrationDate,
          rejectionReason: status == RegistrationStatus.reject ? reason : null,
          approvedDate: status == RegistrationStatus.approve ? DateTime.now() : null,
          rejectedDate: status == RegistrationStatus.reject ? DateTime.now() : null,
          lectureSection: oldReg.lectureSection,
          labSection: oldReg.labSection,
        );
      }

      print('✅ Registration status updated: $registrationId -> ${_statusToString(status)}');
      return 'success';
    } catch (e) {
      print('❌ Error updating status: $e');
      return 'Error: $e';
    }
  }

  // ✅ Get all pending registrations from Firebase
  Future<List<RegistrationModel>> getAllStudentRegistrations() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Registration')
          .where('Status', isEqualTo: 'pending')
          .get();

      final List<RegistrationModel> registrations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        final registration = RegistrationModel(
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
        
        registrations.add(registration);
      }

      print('✅ Loaded ${registrations.length} pending registrations');
      return registrations;
    } catch (e) {
      print('❌ Error getting all registrations: $e');
      return [];
    }
  }

  // ✅ Get approved participants for a subject from Firebase
  Future<List<RegistrationModel>> getSubjectParticipants(String subjectId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Registration')
          .where('SubjectId', isEqualTo: subjectId)
          .where('Status', isEqualTo: 'approved')
          .get();

      final List<RegistrationModel> registrations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        final registration = RegistrationModel(
          registrationId: doc.id,
          studentId: data['StudentId'] ?? '',
          subjectId: data['SubjectId'] ?? '',
          studentName: data['StudentName'] ?? '',
          matricId: data['MatricId'] ?? '',
          subjectCode: data['SubjectCode'] ?? '',
          subjectName: data['SubjectName'] ?? '',
          creditHours: _toInt(data['CreditHours']),
          status: RegistrationStatus.approve,
          registrationDate: (data['RegistrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          rejectionReason: null,
          approvedDate: (data['ApprovedDate'] as Timestamp?)?.toDate(),
          rejectedDate: null,
          lectureSection: data['LectureSection'] ?? 'N/A',
          labSection: data['LabSection'] ?? 'N/A',
        );
        
        registrations.add(registration);
      }

      print('✅ Loaded ${registrations.length} participants for subject: $subjectId');
      return registrations;
    } catch (e) {
      print('❌ Error getting participants: $e');
      return [];
    }
  }

  // ✅ Get registration by ID from Firebase
  Future<RegistrationModel?> getRegistrationById(String registrationId) async {
    try {
      final doc = await _firestore.collection('Registration').doc(registrationId).get();
      
      if (!doc.exists) {
        return null;
      }
      
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
    } catch (e) {
      print('❌ Error getting registration: $e');
      return null;
    }
  }

  // ✅ Initialize from Firebase
  void initMockData() {
    loadSubjectsFromFirebase();
    print('✅ RegistrationController initialized with Firebase');
  }

  // ✅ Refresh all data from Firebase
  Future<void> refreshData() async {
    await loadSubjectsFromFirebase();
    print('✅ Data refreshed from Firebase');
  }
}