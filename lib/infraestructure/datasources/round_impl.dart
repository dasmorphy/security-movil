import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/round_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';

class RoundImpl extends RoundDatasource {
  final Dio dio;

  RoundImpl({required this.dio});
  final uuid = Uuid().v4();

  @override
  Future<ApiResponse<dynamic>> saveRound(Map<String, dynamic> data) async {
    try {
      final images = data['images'] as List<Uint8List>?;
      final roundRegisterData = Map<String, dynamic>.from(data);
      roundRegisterData.remove('images');
      roundRegisterData['channel'] = 'ZENTINEL';
      final roundRegisterJson = jsonEncode(roundRegisterData);
      final roundRegisterBytes = utf8.encode(roundRegisterJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'round_register_data',
          MultipartFile.fromBytes(
            roundRegisterBytes,
            filename: 'round_register_data.json',
            contentType: MediaType('application', 'json'),
          ),
        ),
      );

      // NUEVO: usar Uint8List directamente
      if (images != null && images.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          formData.files.add(
            MapEntry(
              'images',
              MultipartFile.fromBytes(
                images[i],
                filename: 'image_$i.webp', // nombre con índice
                contentType: MediaType('image', 'webp'),
              ),
            ),
          );
        }
      }

      // Aquí puedes agregar la lógica para enviar el JSON al backend usando Dio
      final response = await dio.post(
        '/rest/zent-round-api/v1.0/round-register',
        data: formData,
        options: onlyError(),
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code'],
        message: body['message'],
      );
    } catch (e) {
      print('Error al guardar el registro de rona: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al guardar el registro de ronda',
      );
    }
  }
}
