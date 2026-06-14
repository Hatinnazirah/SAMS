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
}