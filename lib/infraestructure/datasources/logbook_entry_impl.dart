import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:open_filex/open_filex.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';

class LogbookEntryImpl extends LogbookEntryDatasource {
  final Dio dio;

  LogbookEntryImpl({required this.dio});

  @override
  Future<List<Category>> getAllCategory() async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/allCategories',
      options: Options(
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
          'channel': 'ZENTINEL',
        },
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
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
          'channel': 'ZENTINEL',
        },
      ),
    );
    final List unitiesJson = response.data['data'];
    return unitiesJson.map((json) => UnityWeight.fromJson(json)).toList();
  }

  @override
  Future<bool> saveLogbookEntry(Map<String, dynamic> data) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": "fcea920f7412b5da7be0cf42b8c93759",
      "logbook_entry": data,
    };

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/logbook-entry',
      data: dataBody,
      options: onlyError(),
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> saveLogbookOut(Map<String, dynamic> data) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": "fcea920f7412b5da7be0cf42b8c93759",
      "logbook_out": data,
    };

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/logbook-out',
      data: dataBody,
      options: onlyError(),
    );
    return response.statusCode == 200;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistoryLogbooks(filter) async {
    // final userData = ref.read(authProvider);
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/history-logbook',
      options: Options(
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
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
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
          'channel': 'ZENTINEL',
        },
        extra: {'showSuccessMessage': true},
      ),
    );

    // Abrir el archivo automáticamente
    await OpenFilex.open(filePath);
  }
}
