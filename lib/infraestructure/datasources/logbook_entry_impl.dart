import 'dart:convert';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/authorized.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/destiny_intern.dart';
import 'package:zentinel/domain/entities/employee_intern.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/domain/entities/graph_logbook.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zentinel/domain/entities/user_session.dart';

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
    try {
      
      final images = (data['images'] as List?)?.whereType<Uint8List>().toList() ?? [];
      final logbookData = Map<String, dynamic>.from(data);
      logbookData.remove('images');

      logbookData['channel'] = 'ZENTINEL';
      // logbookData['external_transaction_id'] = "1947d6c4-af59-4c26-ae20-e6e935eb7544";

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
      final stopwatch = Stopwatch()..start();

      final response = await dio.post(
        '/rest/zent-logbook-api/v1.0/post/logbook-entry',
        data: formData,
        options: onlyError(),
      );

      stopwatch.stop();
      print('⏱️ Tiempo total request: ${stopwatch.elapsedMilliseconds} ms');
      return response.statusCode == 200 || response.statusCode == 409;
    } on DioException catch (e) {
      print("❌ Error enviando logbook: ${e.message}");
      if (e.response?.statusCode == 409) {
        return true;
      }
      return false;
    }
  }

  @override
  Future<bool> saveLogbookOut(Map<String, dynamic> data) async {

    try {
      
      final images = (data['images'] as List?)?.whereType<Uint8List>().toList() ?? [];
      final logbookData = Map<String, dynamic>.from(data);
      logbookData.remove('images');

      logbookData['channel'] = 'ZENTINEL';
      // logbookData['external_transaction_id'] = "3067dc66-ac5e-49d7-8ef9-eb62c51d4bc6";

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
        '/rest/zent-logbook-api/v1.0/post/logbook-out',
        data: formData,
        options: onlyError(),
      );

      return response.statusCode == 200 || response.statusCode == 409;
    } on DioException catch (e) {
      print("❌ Error enviando logbook: ${e.message}");
      if (e.response?.statusCode == 409) {
        return true;
      }
      return false;
    }
  }

  @override
  Future<List<AllLogbook>> getHistoryLogbooks(filter) async {
    List allLogJson = [];
    try {
      final response = await dio.get(
        '/rest/zent-logbook-api/v1.0/get/all-logbooks-paginated',
        queryParameters: {
          'first': filter['page'] ?? 1,
          'rows': filter['rows'] ?? 5,
          'start_date': filter['start_date'],
          'end_date': filter['end_date'],
          'search': filter['search'],
        },
        options: Options(
          headers: {
            'externalTransactionId': uuid,
            'channel': 'ZENTINEL',
            'user': filter['user'],
            'employees-intern': filter['employees-intern'],
          },
        ),
      );

      allLogJson = response.data?['data']?['data']; 

      return allLogJson.map((json) => AllLogbook.fromJson(json)).toList();
      
    } catch (e) {
      print(e);
      return [];
    }
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

  @override
  Future<List<Authorized>> getAllAuthorized() async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/allAuthorized',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List authorizedJson = response.data['data'];
    return authorizedJson.map((json) => Authorized.fromJson(json)).toList();
  }

  @override
  Future<List<DestinyIntern>> getAllDestinyIntern(Map<String, dynamic> filters) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/allDestinyIntern',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL', 'business': filters['business']},
      ),
    );
    final List destinyJson = response.data['data'];
    return destinyJson.map((json) => DestinyIntern.fromJson(json)).toList();
  }

  @override
  Future<GraphLogbook> getGraphLogbook(Map<String, dynamic> filters) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/resume_graphs?start_date=${filters['start_date']}&end_date=${filters['end_date']}',
      options: Options(
        headers: {
          'externalTransactionId': uuid, 
          'channel': 'ZENTINEL'
        },
      ),
    );
    final GraphLogbook graphsJson = GraphLogbook.fromJson(response.data['data']);
    return graphsJson;
  }
  
  @override
  Future<ApiResponse<dynamic>> saveEmployeeIntern(Map<String, dynamic> data) async {
    try {
      final images = data['photo'] as List<Uint8List>?;
      final employeeData = Map<String, dynamic>.from(data);
      employeeData.remove('photo');
      employeeData['channel'] = 'ZENTINEL';
      final employeeJson = jsonEncode(employeeData);
      final employeeBytes = utf8.encode(employeeJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'employee_data',
          MultipartFile.fromBytes(
            employeeBytes,
            filename: 'employee_data.json',
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
                filename: 'image_$i.webp',         // nombre con índice
                contentType: MediaType('image', 'webp'),
              ),
            ),
          );
        }
      }

      // Aquí puedes agregar la lógica para enviar el JSON al backend usando Dio
      final response = await dio.post(
        '/rest/zent-logbook-api/v1.0/employee-intern',
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
      print('Error al guardar el personal: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al guardar el personal',
      );
    }
  }
  
  @override
  Future<List<EmployeeIntern>> getEmployeeInterns(Map<String, dynamic> filters) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/employee-intern',
      queryParameters: {
        'start_date': filters['start_date'],
        'end_date': filters['end_date'],
        'id_employee': filters['id_employee'],
        'id_group_business': filters['id_group_business'],
      },
      options: Options(
        headers: {
          'externalTransactionId': uuid, 
          'channel': 'ZENTINEL'
        },
      ),
    );
    final List<EmployeeIntern> employeeInterns = (response.data['data'] as List)
      .map((json) => EmployeeIntern.fromJson(json))
      .toList();
    return employeeInterns;
  }

  @override
  Future<List<EmployeeMovement>> getEmployeeMovements(Map<String, dynamic> filters) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/employee-movement',
      queryParameters: {
        'start_date': filters['start_date'],
        'end_date': filters['end_date'],
        'id_employee': filters['id_employee'],
        'type_movement': filters['type_movement'],
        'group_business_id': filters['group_business_id'],
        'status_employee': filters['status_employee'],
      },
      options: Options(
        headers: {
          'externalTransactionId': uuid, 
          'channel': 'ZENTINEL'
        },
      ),
    );
    final data = response.data['data'] as List? ?? [];
    return data
    .map((json) => EmployeeMovement.fromJson(json))
    .toList();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveEmployeeMovement(Map<String, dynamic> data) async {
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
  
  @override
  Future<ApiResponse<dynamic>> updateStatusEmployeeIntern(Map<String, dynamic> data) async {
    try {
      final idEmployee = data["id_employee"];
      final response = await dio.patch(
        '/rest/zent-logbook-api/v1.0/employee-intern/$idEmployee',
        data: {
          'externalTransactionId': uuid, 
          'channel': 'ZENTINEL',
          'data': {
            "status": data["status"],
            "user_update": data["user_update"]
          }
        },
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
      print('Error al guardar estado: $e');
      String messageError = "Error al guardar estado";
      if (e is DioException) {
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
  Future<List<User>> getUsers(Map<String, dynamic> filters) async {
    final response = await dio.get(
      '/rest/zent-logbook-api/v1.0/get/all-users',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL', 'roles': filters['roles']},
      ),
    );
    final List userJson = response.data['data'];
    return userJson.map((json) => User.fromJson(json)).toList();
  }
}
