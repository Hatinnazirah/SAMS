import '../../Domain/ManageCurriculumCoCurriculumActivities/CurriculumModulesModel.dart';

class StudentController {
  
  // Make this static so it persists across all instances
  static List<CurriculumModulesModel> _registeredModulesList = [];
  
  // ==============================================
  // MODULE BOOKING METHODS
  // ==============================================
  
  Future<List<CurriculumModulesModel>> getAvailableSubjects() async {
    await Future.delayed(Duration(seconds: 1));
    
    return [
      CurriculumModulesModel(
        ModuleID: '1',
        ModuleCode: 'HQD3022',
        ModuleName: 'MOBILE PHONE PHOTOGRAPHY',
        scheduleSlots: [
          {'date': '11/4/2026', 'venue': 'Online', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '18/4/2026', 'venue': 'Online', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '25/4/2026', 'venue': 'Online', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '2/5/2026', 'venue': 'Online', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '2',
        ModuleCode: 'HQP3022',
        ModuleName: 'PENGURUSAN MAJLIS',
        scheduleSlots: [
          {'date': '12/4/2026', 'venue': 'DK1', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '19/4/2026', 'venue': 'DK1', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '26/4/2026', 'venue': 'DK1', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '3/5/2026', 'venue': 'DK1', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '3',
        ModuleCode: 'HQR3022',
        ModuleName: 'PSYCHOLOGICAL FIRST AID',
        scheduleSlots: [
          {'date': '13/4/2026', 'venue': 'Online', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '20/4/2026', 'venue': 'Online', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '27/4/2026', 'venue': 'Online', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '4/5/2026', 'venue': 'Online', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '4',
        ModuleCode: 'HQD3062',
        ModuleName: 'EDIT LIKE A PRO WITH CANVA',
        scheduleSlots: [
          {'date': '11/4/2026', 'venue': 'Lab 2', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '18/4/2026', 'venue': 'Lab 2', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '25/4/2026', 'venue': 'Lab 2', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '2/5/2026', 'venue': 'Lab 2', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '5',
        ModuleCode: 'HQS3012',
        ModuleName: 'ASAS CATUR',
        scheduleSlots: [
          {'date': '14/4/2026', 'venue': 'Bilik Khas', 'startTime': '03:00 PM', 'endTime': '05:00 PM'},
          {'date': '21/4/2026', 'venue': 'Bilik Khas', 'startTime': '03:00 PM', 'endTime': '05:00 PM'},
          {'date': '28/4/2026', 'venue': 'Bilik Khas', 'startTime': '03:00 PM', 'endTime': '05:00 PM'},
          {'date': '5/5/2026', 'venue': 'Bilik Khas', 'startTime': '03:00 PM', 'endTime': '05:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '6',
        ModuleCode: 'UHS1221',
        ModuleName: 'THEATRE',
        scheduleSlots: [
          {'date': '15/4/2026', 'venue': 'Auditorium', 'startTime': '11:00 AM', 'endTime': '02:00 PM'},
          {'date': '22/4/2026', 'venue': 'Auditorium', 'startTime': '11:00 AM', 'endTime': '02:00 PM'},
          {'date': '29/4/2026', 'venue': 'Auditorium', 'startTime': '11:00 AM', 'endTime': '02:00 PM'},
          {'date': '6/5/2026', 'venue': 'Auditorium', 'startTime': '11:00 AM', 'endTime': '02:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '7',
        ModuleCode: 'UHS1241',
        ModuleName: 'VISUAL ARTS',
        scheduleSlots: [
          {'date': '16/4/2026', 'venue': 'Studio', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '23/4/2026', 'venue': 'Studio', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '30/4/2026', 'venue': 'Studio', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
          {'date': '7/5/2026', 'venue': 'Studio', 'startTime': '10:00 AM', 'endTime': '01:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '8',
        ModuleCode: 'UHS1411',
        ModuleName: 'COMMUNITY SERVICE',
        scheduleSlots: [
          {'date': '17/4/2026', 'venue': 'External', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '24/4/2026', 'venue': 'External', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '1/5/2026', 'venue': 'External', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
          {'date': '8/5/2026', 'venue': 'External', 'startTime': '08:00 AM', 'endTime': '05:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '9',
        ModuleCode: 'UHS1811',
        ModuleName: 'ROBOTICS CLUB',
        scheduleSlots: [
          {'date': '18/4/2026', 'venue': 'Lab 3', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '25/4/2026', 'venue': 'Lab 3', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '2/5/2026', 'venue': 'Lab 3', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
          {'date': '9/5/2026', 'venue': 'Lab 3', 'startTime': '02:00 PM', 'endTime': '05:00 PM'},
        ],
      ),
      CurriculumModulesModel(
        ModuleID: '10',
        ModuleCode: 'UHS1631',
        ModuleName: 'PUBLIC SPEAKING',
        scheduleSlots: [
          {'date': '19/4/2026', 'venue': 'DK2', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '26/4/2026', 'venue': 'DK2', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '3/5/2026', 'venue': 'DK2', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
          {'date': '10/5/2026', 'venue': 'DK2', 'startTime': '09:00 AM', 'endTime': '12:00 PM'},
        ],
      ),
    ];
  }
  
  void returnSubjectList(List<CurriculumModulesModel> subjectList) {
    print("Subject list sent to ModuleBookingPage");
  }
  
  Future<bool> validateRegistrationData(String StudentID, String ModuleID) async {
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }
  
  Future<void> saveRegistrationData(String StudentID, String ModuleID, CurriculumModulesModel module) async {
    await Future.delayed(Duration(seconds: 1));
    // Check if module already exists to avoid duplicates
    bool alreadyExists = _registeredModulesList.any((m) => m.ModuleID == module.ModuleID);
    if (!alreadyExists) {
      _registeredModulesList.add(module);
      print("Module added: ${module.ModuleName}");
    }
    returnSaveConfirmation();
  }
  
  void returnSaveConfirmation() {
    print("Registration saved successfully");
  }
  
  Future<List<CurriculumModulesModel>> getRegisteredSubjects(String StudentID) async {
    await Future.delayed(Duration(seconds: 1));
    print("Returning ${_registeredModulesList.length} registered modules");
    return List.from(_registeredModulesList);
  }
  
  void returnRegisteredSubjects(List<CurriculumModulesModel> registeredSubjectsList) {
    print("Registered subjects sent to MySubjectsPage");
  }
  
  Future<void> dropSubject(String ModuleID) async {
    await Future.delayed(Duration(seconds: 1));
    _registeredModulesList.removeWhere((module) => module.ModuleID == ModuleID);
    print("Module dropped: $ModuleID");
    returnDropConfirmation();
  }
  
  void returnDropConfirmation() {
    print("Module dropped successfully");
  }
  
  Future<bool> validateActivityData(String StudentID, String ModuleID, String ActivityName, String DocumentURL) async {
    await Future.delayed(Duration(milliseconds: 500));
    return ActivityName.isNotEmpty && DocumentURL.isNotEmpty;
  }
  
  Future<void> saveActivityData(String StudentID, String ModuleID, String ActivityName, String DocumentURL) async {
    await Future.delayed(Duration(seconds: 1));
    returnSaveConfirmation();
  }
  
  Future<List<CurriculumModulesModel>> getRecordedModules(String StudentID) async {
    await Future.delayed(Duration(seconds: 1));
    return [];
  }
  
  void returnRecordedModules(List<CurriculumModulesModel> recordedModulesList) {
    print("Recorded modules sent to CreditClaimPage");
  }
  
  Future<bool> validateClaimData(String StudentID, String ModuleID) async {
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }
  
  Future<void> saveCreditClaimData(String StudentID, String ModuleID, int CreditsClaimed) async {
    await Future.delayed(Duration(seconds: 1));
    returnSaveConfirmation();
  }

  // Get completed modules (for credit claim)
Future<List<Map<String, dynamic>>> getCompletedModules(String StudentID) async {
  await Future.delayed(Duration(seconds: 1));
  
  // Dummy completed modules data
  return [
    {
      'id': '1',
      'moduleCode': 'HQD3062',
      'moduleName': 'EDIT LIKE A PRO WITH CANVA',
      'classDate': '2 May 2026',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 3,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '2',
      'moduleCode': 'HQP3022',
      'moduleName': 'PENGURUSAN MAJLIS',
      'classDate': '6/12/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 2,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '3',
      'moduleCode': 'UHS1221',
      'moduleName': 'THEATRE',
      'classDate': '31/05/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 1,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '4',
      'moduleCode': 'HQS3012',
      'moduleName': 'ASAS CATUR',
      'classDate': '24/05/2025',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 2,
      'claimStatus': 'not_claimed',
    },
    {
      'id': '5',
      'moduleCode': 'HQD3022',
      'moduleName': 'MOBILE PHONE PHOTOGRAPHY',
      'classDate': '21/12/2024',
      'startTime': '08:00 AM',
      'endTime': '05:00 PM',
      'credits': 3,
      'claimStatus': 'not_claimed',
    },
  ];
}
}