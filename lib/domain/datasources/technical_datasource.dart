import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/client_technical.dart';
import 'package:zentinel/domain/entities/location_technical.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';

abstract class TechnicalDatasource {
  Future<List<TaskTechnical>> getTaskTechnical();
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data);
  Future<List<TechMaterial>> getTechMeterial();
  Future<List<AuditingSection>> getAuditingSection();
  Future<ApiResponse<dynamic>> saveAuditing(Map<String, dynamic> data);
  Future<List<ClientTechnical>> getClientsTechnical();
  Future<List<LocationTechnical>> getLocationTechnical(Map<String, dynamic> filters);
  Future<ApiResponse<dynamic>> saveProjectTechnical(Map<String, dynamic> data);
}