import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
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

  @override
  Future<ApiResponse<dynamic>> saveTechnicalRecord(Map<String, dynamic> data) async {
    try {
      final images = (data['images'] as List?)?.whereType<Uint8List>().toList() ?? [];
      final movementData = Map<String, dynamic>.from(data);
      movementData.remove('images');

      movementData['channel'] = 'ZENTINEL';
      // movementData['external_transaction_id'] = "3067dc66-ac5e-49d7-8ef9-eb62c51d4bc6";

      final movementJson = jsonEncode(movementData);
      final movementBytes = utf8.encode(movementJson);

      final formData = FormData();

      // Agregar logbook_out
      formData.files.add(
        MapEntry(
          'employee_movement',
          MultipartFile.fromBytes(
            movementBytes,
            filename: 'employee_movement.json',
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      // NUEVO: usar Uint8List directamente
      if (images.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          formData.files.add(
            MapEntry(
              'images',
              MultipartFile.fromBytes(
                images[i],
                filename: 'image_$i.webp',         // nombre con índice
                contentType: MediaType('image', 'webp'),
              ),
            ),
          );
        }
      }

      final response = await dio.post(
        '/rest/zent-logbook-api/v1.0/employee-movement',
        data: formData,
        options: onlyError(),
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code']?.toString(),
        message: body['message'],
        data: body['data'],
      );
    } catch (e) {
      print('Error al guardar registro: $e');
      String messageError = "Error al guardar el registro";
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          rethrow;
        }
        messageError = e.response?.data["message"];
      }
      return ApiResponse(
        success: false,
        errorCode: 'save_error',
        message: messageError,
      );
    }
  }

}