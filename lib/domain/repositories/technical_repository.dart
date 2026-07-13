  
import 'package:zentinel/domain/entities/task_technical.dart';

abstract class TechnicalRepository {
  Future<List<TaskTechnical>> getTaskTechnical();
}
