import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/technical_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

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

  @override
  Future<List<AuditingSection>> getAuditingSection() async {
    final response = await dio.get(
      '/rest/technical-control-api/v1.0/auditing-sections',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List sectionJson = response.data['data'];
    return sectionJson.map((json) => AuditingSection.fromJson(json)).toList();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveAuditing(Map<String, dynamic> data) async {
    try {
      final List<FindingEntry> findings = data['finding_images'] as List<FindingEntry>;
      final auditorImg = data['auditor_img'] as Uint8List?;
      final responsibleImg = data['responsible_img'] as Uint8List?;
      final clientImg = data['client_img'] as Uint8List?;

      final techRecordData = Map<String, dynamic>.from(data);
      techRecordData.remove('auditor_img');
      techRecordData.remove('responsible_img');
      techRecordData.remove('client_img');
      techRecordData.remove('finding_images');

      techRecordData['channel'] = 'ZENTINEL';

      final techRecordJson = jsonEncode(techRecordData);
      final techRecordBytes = utf8.encode(techRecordJson);

      final formData = FormData();

      // Agregar logbook_out
      formData.files.add(
        MapEntry(
          'data',
          MultipartFile.fromBytes(
            techRecordBytes,
            filename: 'data.json',
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      for (final entry in findings.asMap().entries) {
        final findingIndex = entry.key;
        final finding = entry.value;

        for (final imageEntry in finding.image.asMap().entries) {
          final imageIndex = imageEntry.key;

          formData.files.add(
            MapEntry(
              'finding_${findingIndex}_$imageIndex',
              MultipartFile.fromBytes(
                imageEntry.value,
                filename: 'finding_${findingIndex}_$imageIndex.webp',
                contentType: MediaType('image', 'webp'),
              ),
            ),
          );
        }
      }

      // NUEVO: usar Uint8List directamente
      if (auditorImg != null) {
        formData.files.add(
          MapEntry(
            'auditor_img',
            MultipartFile.fromBytes(
              auditorImg,
              filename: 'auditor_img.webp',         // nombre con índice
              contentType: MediaType('image', 'webp'),
            ),
          ),
        );
      }

      if (responsibleImg != null) {
        formData.files.add(
          MapEntry(
            'responsible_img',
            MultipartFile.fromBytes(
              responsibleImg,
              filename: 'responsible_img.webp',         // nombre con índice
              contentType: MediaType('image', 'webp'),
            ),
          ),
        );
      }

      if (clientImg != null) {
        formData.files.add(
          MapEntry(
            'client_img',
            MultipartFile.fromBytes(
              clientImg,
              filename: 'client_img.webp',         // nombre con índice
              contentType: MediaType('image', 'webp'),
            ),
          ),
        );
      }

      final response = await dio.post(
        '/rest/technical-control-api/v1.0/auditing',
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