  
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';

abstract class TechnicalRepository {
  Future<List<TaskTechnical>> getTaskTechnical();
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data);
  Future<List<TechMaterial>> getTechMeterial();
  Future<List<AuditingSection>> getAuditingSection();
}
