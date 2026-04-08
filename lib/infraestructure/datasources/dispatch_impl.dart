import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/dispatch_datasource.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/dispatch_status.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';

class DispatchImpl extends DispatchDatasource {
  final Dio dio;

  DispatchImpl({required this.dio});
  final uuid = Uuid().v4();

  @override
  Future<List<DispatchProducts>> getAllDispatchProducts() async{
    final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/dispatch-products-sku',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List productsJson = response.data['data'];
    return productsJson.map((json) => DispatchProducts.fromJson(json)).toList();
  }

  @override
  Future<ApiResponse> saveDispatch(Map<String, dynamic> data) async {
     try {
      final images = data['images'] as List<Uint8List>?;
      final dispatchData = Map<String, dynamic>.from(data);
      dispatchData.remove('images');
      dispatchData['channel'] = 'ZENTINEL';
      final dispatchJson = jsonEncode(dispatchData);
      final dispatchBytes = utf8.encode(dispatchJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'dispatch_data',
          MultipartFile.fromBytes(
            dispatchBytes,
            filename: 'dispatch_data.json',
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
        '/rest/zent-dispatch-api/v1.0/dispatch',
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
      print('Error al guardar el dispatch: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al guardar el despacho',
      );
    }
  }
  
  @override
  Future<List<VehicleType>> getAllVehicleTypes() async {
    final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/vehicle-types',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List vehiclesJson = response.data['data'];
    return vehiclesJson.map((json) => VehicleType.fromJson(json)).toList();
  }

  @override
  Future<List<AllDispatch>> getHistoryDispatch(Map<String, dynamic> filters) async {
    List allDispatchJson = [];
    try {
      final response = await dio.get(
        '/rest/zent-dispatch-api/v1.0/dispatch',
        options: Options(
          headers: {
            'externalTransactionId': uuid,
            'channel': 'ZENTINEL',
            'user': filters['user'],
          },
        ),
      );

      allDispatchJson = response.data['data']; 
      return allDispatchJson.map((json) => AllDispatch.fromJson(json)).toList();
      
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<ApiResponse<dynamic>> updateDispatch(Map<String, dynamic> data) async {
    try {      
      final dispatchData = Map<String, dynamic>.from(data);

      final dispatchJson = {
        "dispatch_data": dispatchData,
        "external_transaction_id": uuid,
        "channel": 'ZENTINEL', 
      };

      final response = await dio.patch(
        '/rest/zent-dispatch-api/v1.0/dispatch/${data['dispatch_id']}',
        data: jsonEncode(dispatchJson),
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code']?.toString(),
        message: body['message'],
      );
    } catch (e) {
      print('Error al guardar el dispatch: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al actualizar despacho',
      );
    }
  }

  @override
  Future<List<DispatchStatus>> getDispatchStatus() async {
    final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/status-dispatch',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    final List statusJson = response.data['data'];
    return statusJson.map((json) => DispatchStatus.fromJson(json)).toList();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveReception(Map<String, dynamic> data) async {
    try {
      final images = data['images'] as List<Uint8List>?;
      final receptionData = Map<String, dynamic>.from(data);
      receptionData.remove('images');
      receptionData['channel'] = 'ZENTINEL';
      final receptionJson = jsonEncode(receptionData);
      final receptionBytes = utf8.encode(receptionJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'reception_data',
          MultipartFile.fromBytes(
            receptionBytes,
            filename: 'reception_data.json',
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

      final response = await dio.post(
        '/rest/zent-dispatch-api/v1.0/reception',
        data: formData,
        options: onlyError(),
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code']?.toString(),
        message: body['message'],
      );
    } catch (e) {
      print('Error al guardar el dispatch: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al guardar la recepción',
      );
    }
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getAreasVisit() async {
     final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/area-visit',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getMaterials() async {
     final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/materials',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getStaffCharge() async {
     final response = await dio.get(
      '/rest/zent-dispatch-api/v1.0/staff-charge',
      options: Options(
        headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
      ),
    );
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  
  @override
  Future<ApiResponse<dynamic>> saveEntry(Map<String, dynamic> data) async {
    try {
      final images = data['images'] as List<Uint8List>?;
      final entryControlData = Map<String, dynamic>.from(data);
      entryControlData.remove('images');
      entryControlData['channel'] = 'ZENTINEL';
      final entryControlJson = jsonEncode(entryControlData);
      final entryControlBytes = utf8.encode(entryControlJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'entry_data',
          MultipartFile.fromBytes(
            entryControlBytes,
            filename: 'entry_data.json',
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
        '/rest/zent-dispatch-api/v1.0/entry-access',
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
      print('Error al guardar el ingreso: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al guardar el ingreso',
      );
    }
  }

  @override
  Future<List<EntryAccessControl>> getHistoryEntryAccess(Map<String, dynamic> filters) async {
    List entryAcessJson = [];
    try {
      final response = await dio.get(
        '/rest/zent-dispatch-api/v1.0/entry-access',
        options: Options(
          headers: {
            'externalTransactionId': uuid,
            'channel': 'ZENTINEL',
            'user': filters['user'],
          },
        ),
      );

      entryAcessJson = response.data['data']; 
      return entryAcessJson.map((json) => EntryAccessControl.fromJson(json)).toList();
      
    } catch (e) {
      print(e);
      return [];
    }
  }
  
  @override
  Future<ApiResponse<dynamic>> updateEntry(Map<String, dynamic> data) async {
    try {
      final images = data['images'] as List<Uint8List>?;
      final entryControlData = Map<String, dynamic>.from(data);
      entryControlData.remove('images');
      entryControlData['channel'] = 'ZENTINEL';
      final entryControlJson = jsonEncode(entryControlData);
      final entryControlBytes = utf8.encode(entryControlJson);

      final formData = FormData();

      formData.files.add(
        MapEntry(
          'entry_data',
          MultipartFile.fromBytes(
            entryControlBytes,
            filename: 'entry_data.json',
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

      final response = await dio.patch(
        '/rest/zent-dispatch-api/v1.0/entry-access/${data['entry_access_id']}',
        data: formData,
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code']?.toString(),
        message: body['message'],
      );
    } catch (e) {
      print('Error al actualizar el registro: $e');
      return ApiResponse(
        success: false,
        errorCode: 'update_error',
        message: 'Error al actualizar el registro',
      );
    }
  }

}