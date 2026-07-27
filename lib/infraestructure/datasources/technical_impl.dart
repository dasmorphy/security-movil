import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';

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
      final techRecordData = Map<String, dynamic>.from(data);
      techRecordData.remove('images');

      techRecordData['channel'] = 'ZENTINEL';

      final techRecordJson = jsonEncode(techRecordData);
      final techRecordBytes = utf8.encode(techRecordJson);

      final formData = FormData();

      // Agregar logbook_out
      formData.files.add(
        MapEntry(
          'technical_data',
          MultipartFile.fromBytes(
            techRecordBytes,
            filename: 'technical_data.json',
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
        '/rest/technical-control-api/v1.0/technical_record',
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

  @override
  Future<List<TechMaterial>> getTechMeterial() async {
    final response = await dio.get(
      '/rest/technical-control-api/v1.0/tech-materials',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List taskJson = response.data['data'];
    return taskJson.map((json) => TechMaterial.fromJson(json)).toList();
  }

}