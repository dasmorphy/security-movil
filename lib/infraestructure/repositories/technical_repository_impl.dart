import 'package:zentinel/domain/datasources/technical_datasource.dart';
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
import 'package:zentinel/domain/repositories/technical_repository.dart';

class TechnicalRepositoryImpl extends TechnicalRepository {

  final TechnicalDatasource datasource;
  TechnicalRepositoryImpl(this.datasource);

  @override
  Future<List<TaskTechnical>> getTaskTechnical(Map<String, dynamic> filters) {
    return datasource.getTaskTechnical(filters);
  }

  @override
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data) {
    return datasource.saveTechnicalRecord(data);
  }

  @override
  Future<List<TechMaterial>> getTechMeterial() {
    return datasource.getTechMeterial();
  }

  @override
  Future<List<AuditingSection>> getAuditingSection() {
    return datasource.getAuditingSection();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveAuditing(Map<String, dynamic> data) {
    return datasource.saveAuditing(data);
  }

  @override
  Future<List<ClientTechnical>> getClientsTechnical() {
    return datasource.getClientsTechnical();
  }

  @override
  Future<List<LocationTechnical>> getLocationTechnical(Map<String, dynamic> filters) {
    return datasource.getLocationTechnical(filters);
  }
  
  @override
  Future<ApiResponse<dynamic>> saveProjectTechnical(Map<String, dynamic> data) {
    return datasource.saveProjectTechnical(data);
  }

  @override
  Future<ApiResponse<dynamic>> updateStatusProject(Map<String, dynamic> data) {
    return datasource.updateStatusProject(data);
  }

  @override
  Future<List<TechnicalStaff>> getTechnicalStaff() {
    return datasource.getTechnicalStaff();
  }

  @override
  Future<List<HistoryStatusProject>> getHistoryStatusProject(Map<String, dynamic> filters) {
    return datasource.getHistoryStatusProject(filters);
  }

  @override
  Future<List<TechnicalRecord>> getTechnicalRecord(Map<String, dynamic> filters) {
    return datasource.getTechnicalRecord(filters);
  }

  @override
  Future<GraphTechnical> getGraphTechnical(Map<String, dynamic> filters) {
    return datasource.getGraphTechnical(filters);
  }

  @override
  Future<ApiResponse<dynamic>> patchTechnicalRecord(Map<String, dynamic> data) {
    return datasource.patchTechnicalRecord(data);
  }
  
  @override
  Future<ApiResponse<dynamic>> saveLocationClient(Map<String, dynamic> data) {
    return datasource.saveLocationClient(data);
  }
}