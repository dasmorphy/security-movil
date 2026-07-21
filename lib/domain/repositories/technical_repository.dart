  
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/task_technical.dart';

abstract class TechnicalRepository {
  Future<List<TaskTechnical>> getTaskTechnical();
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data);
}
