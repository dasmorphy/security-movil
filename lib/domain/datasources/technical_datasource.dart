import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/client_technical.dart';
import 'package:zentinel/domain/entities/graph_technical.dart';
import 'package:zentinel/domain/entities/history_status_project.dart';
import 'package:zentinel/domain/entities/location_technical.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/domain/entities/technical_staff.dart';

abstract class TechnicalDatasource {
  Future<List<TaskTechnical>> getTaskTechnical(Map<String, dynamic> filters);
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> patchTechnicalRecord(Map<String, dynamic> data);
  Future<List<TechMaterial>> getTechMeterial();
  Future<List<AuditingSection>> getAuditingSection();
  Future<ApiResponse<dynamic>> saveAuditing(Map<String, dynamic> data);
  Future<List<ClientTechnical>> getClientsTechnical();
  Future<List<LocationTechnical>> getLocationTechnical(Map<String, dynamic> filters);
  Future<ApiResponse<dynamic>> saveProjectTechnical(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> updateStatusProject(Map<String, dynamic> data);
  Future<List<TechnicalStaff>> getTechnicalStaff();
  Future<List<HistoryStatusProject>> getHistoryStatusProject(Map<String, dynamic> filters);
  Future<List<TechnicalRecord>> getTechnicalRecord(Map<String, dynamic> filters);
  Future<GraphTechnical> getGraphTechnical(Map<String, dynamic> filters);
}