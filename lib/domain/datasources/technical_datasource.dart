import 'package:zentinel/domain/entities/task_technical.dart';

abstract class TechnicalDatasource {
  Future<List<TaskTechnical>> getTaskTechnical();

}