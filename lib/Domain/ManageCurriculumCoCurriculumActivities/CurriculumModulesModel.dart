class CurriculumModulesModel {
  String ModuleID;
  String ModuleCode;
  String ModuleName;
  List<Map<String, dynamic>> scheduleSlots;

  CurriculumModulesModel({
    required this.ModuleID,
    required this.ModuleCode,
    required this.ModuleName,
    required this.scheduleSlots,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'ModuleID': ModuleID,
      'ModuleCode': ModuleCode,
      'ModuleName': ModuleName,
      'scheduleSlots': scheduleSlots,
    };
  }

  // Create from Firebase data
  factory CurriculumModulesModel.fromJson(Map<String, dynamic> json, String docId) {
    List<Map<String, dynamic>> slots = [];
    
    if (json['scheduleSlots'] != null && json['scheduleSlots'] is List) {
      slots = List<Map<String, dynamic>>.from(json['scheduleSlots']);
    }
    
    return CurriculumModulesModel(
      ModuleID: docId,
      ModuleCode: json['ModuleCode'] ?? json['moduleCode'] ?? '',
      ModuleName: json['ModuleName'] ?? json['moduleName'] ?? '',
      scheduleSlots: slots,
    );
  }
}