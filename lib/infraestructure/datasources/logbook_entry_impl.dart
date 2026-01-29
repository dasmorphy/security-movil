import 'package:dio/dio.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

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
    print(response);
    final List categoriesJson = response.data['data'];
    return categoriesJson
      .map((json) => Category.fromJson(json))
      .toList();
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
    return unitiesJson
      .map((json) => UnityWeight.fromJson(json))
      .toList();
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
      print(response);
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
    print(response);
    return response.statusCode == 200;
  }
}
