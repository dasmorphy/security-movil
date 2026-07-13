import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/task_technical.dart';

class TechnicalImpl extends TechnicalDatasource {
  final Dio dio;

  TechnicalImpl({required this.dio});
  final uuid = Uuid().v4();

  @override
  Future<List<TaskTechnical>> getTaskTechnical() async {
    final response = await dio.get(
      '/rest/technical-control-api/v1.0/task',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List taskJson = response.data['data'];
    return taskJson.map((json) => TaskTechnical.fromJson(json)).toList();
  }

}