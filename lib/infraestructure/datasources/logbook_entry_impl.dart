import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';

class LogbookEntryImpl extends LogbookEntryDatasource {
  final Dio dio;

  LogbookEntryImpl({required this.dio});
  final uuid = Uuid().v4();

  @override
  Future<List<Category>> getAllCategory() async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/allCategories',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List categoriesJson = response.data['data'];
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  @override
  Future<List<UnityWeight>> getAllUnityWeight() async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/allUnitiesWeight',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List unitiesJson = response.data['data'];
    return unitiesJson.map((json) => UnityWeight.fromJson(json)).toList();
  }

  @override
  Future<bool> saveLogbookEntry(Map<String, dynamic> data) async {
    final images = data['images'] as List<File>?;
    final logbookData = Map<String, dynamic>.from(data);
    logbookData.remove('images');

    logbookData['channel'] = 'ZENTINEL';
    logbookData['external_transaction_id'] = Uuid().v4();

    final logbookJson = jsonEncode(logbookData);
    final logbookBytes = utf8.encode(logbookJson);

    final formData = FormData();

    // Agregar logbook_entry
    formData.files.add(
      MapEntry(
        'logbook_entry',
        MultipartFile.fromBytes(
          logbookBytes,
          filename: 'logbook_entry.json',
          contentType: MediaType('application', 'json'),
        ),
      ),
    );

    // Agregar imágenes
    if (images != null && images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        final image = images[i];
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
              contentType: getMediaType(image.path),
            ),
          ),
        );
      }
    }
    final stopwatch = Stopwatch()..start();

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/logbook-entry',
      data: formData,
      options: onlyError(),
    );

    stopwatch.stop();
    print('⏱️ Tiempo total request: ${stopwatch.elapsedMilliseconds} ms');
    return response.statusCode == 200;
  }

  @override
  Future<bool> saveLogbookOut(Map<String, dynamic> data) async {
    final images = data['images'] as List<File>?;
    final logbookData = Map<String, dynamic>.from(data);
    logbookData.remove('images');

    logbookData['channel'] = 'ZENTINEL';
    logbookData['external_transaction_id'] = Uuid().v4();

    final logbookJson = jsonEncode(logbookData);
    final logbookBytes = utf8.encode(logbookJson);

    final formData = FormData();

    // Agregar logbook_out
    formData.files.add(
      MapEntry(
        'logbook_out',
        MultipartFile.fromBytes(
          logbookBytes,
          filename: 'logbook_out.json',
          contentType: MediaType('application', 'json'),
        ),
      ),
    );

    // Agregar imágenes
    if (images != null && images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        final image = images[i];
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
              contentType: getMediaType(image.path),
            ),
          ),
        );
      }
    }
    final stopwatch = Stopwatch()..start();

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/logbook-out',
      data: formData,
      options: onlyError(),
    );
stopwatch.stop();
    print('⏱️ Tiempo total request: ${stopwatch.elapsedMilliseconds} ms');
    return response.statusCode == 200;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistoryLogbooks(filter) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/history-logbook',
      options: Options(
        headers: {
          'externalTransactionId': uuid,
          'channel': 'ZENTINEL',
          'user': filter['user'],
        },
      ),
    );

    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  @override
  Future<void> downloadExcel() async {
    // Directorio seguro (NO requiere permisos)
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/logbook.xlsx';

    await dio.download(
      '/rest/zent-logbook-api/v1.0/get/generate_report',
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
        extra: {'showSuccessMessage': true},
      ),
    );

    // Abrir el archivo automáticamente
    await OpenFilex.open(filePath);
  }

  @override
  Future<List<GroupBusiness>> getGroupBusinessByIdBusiness(
    int idBusinness,
  ) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/group-business-by-id-business/$idBusinness',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );

    final List groupBusinessJson = response.data['data'];
    return groupBusinessJson
        .map((json) => GroupBusiness.fromJson(json))
        .toList();
  }
}
