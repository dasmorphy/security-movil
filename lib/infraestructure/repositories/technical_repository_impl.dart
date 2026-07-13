import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/repositories/technical_repository.dart';

class TechnicalRepositoryImpl extends TechnicalRepository {

  final TechnicalDatasource datasource;
  TechnicalRepositoryImpl(this.datasource);

  @override
  Future<List<TaskTechnical>> getTaskTechnical() {
    return datasource.getTaskTechnical();
  }

}