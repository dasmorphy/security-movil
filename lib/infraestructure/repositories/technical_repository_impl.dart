import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/domain/repositories/technical_repository.dart';

class TechnicalRepositoryImpl extends TechnicalRepository {

  final TechnicalDatasource datasource;
  TechnicalRepositoryImpl(this.datasource);

  @override
  Future<List<TaskTechnical>> getTaskTechnical() {
    return datasource.getTaskTechnical();
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

}