import 'package:dio/dio.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/infraestructure/dto/logbook_entry_dto.dart';

class LogbookEntryImpl extends LogbookEntryDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      // queryParameters: {
      //   'api_key': Environments.movieDbKey,
      //   'language': 'es-MX'
      // }
    )
  );

  @override
  Future<List<Category>> getAllCategory() async {
    final response = await dio.get('/rest/zent-logbook-api/v1.0/get/allCategories',
      options: Options(
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
          'channel': 'ZENTINEL'
        },
      ), 
    );
    print(response);
    final List categoriesJson = response.data['data'];
    final List<Category> categories = categoriesJson
      .map((json) => Category.fromJson(json))
      .toList();
    print(categories);
    return categories;
  }

  @override
  Future<List<UnityWeight>> getAllUnityWeight() async {
    final response = await dio.get('/rest/zent-logbook-api/v1.0/get/allUnitiesWeight',
      options: Options(
        headers: {
          'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
          'channel': 'ZENTINEL'
        },
      ), 
    );
    final List unitiesJson = response.data['data'];
    final List<UnityWeight> unitsWeight = unitiesJson
      .map((json) => UnityWeight.fromJson(json))
      .toList();
    // final List<UnityWeight> unitsWeight = response.data;
    return unitsWeight;
  }

  @override
  Future<String> saveLogbookEntry(Map<String, dynamic> data) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": "fcea920f7412b5da7be0cf42b8c93759",
      "logbook_entry": data
    };

    final response = await dio.post('/rest/zent-logbook-api/v1.0/post/logbook-entry', data: dataBody);
    print(response);
    final String message = response.data['message'];
    return message;
  }
  

}