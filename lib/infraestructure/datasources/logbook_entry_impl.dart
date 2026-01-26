import 'package:dio/dio.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

class LogbookEntryImpl extends LogbookEntryDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'externalTransactionId': 'fcea920f7412b5da7be0cf42b8c93759',
        'channel': 'ZENTINEL'
      },
      // queryParameters: {
      //   'api_key': Environments.movieDbKey,
      //   'language': 'es-MX'
      // }
    )
  );

  @override
  Future<List<Category>> getAllCategory() async {
    final response = await dio.get('/rest/zent-logbook-api/v1.0/get/allCategories');
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
    final response = await dio.get('/rest/zent-logbook-api/v1.0/get/units_weight');
    final List<UnityWeight> unitsWeight = response.data;
    return unitsWeight;
  }
  
  

}