import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/datasources/dispatch_datasource.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/dispatch_status.dart';
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
      final logbookData = Map<String, dynamic>.from(data);
      logbookData.remove('images');

      final dispatchData = {
        "dispatch_data": logbookData,
        "external_transaction_id": uuid,
        "channel": 'ZENTINEL', 
      };

      // logbookData['channel'] = 'ZENTINEL';
      // logbookData['external_transaction_id'] = "1947d6c4-af59-4c26-ae20-e6e935eb7544";

      final logbookJson = jsonEncode(dispatchData);

      // Aquí puedes agregar la lógica para enviar el JSON al backend usando Dio
      final response = await dio.post(
        '/rest/zent-dispatch-api/v1.0/dispatch',
        data: logbookJson,
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
        message: 'Error al actualizar despacho',
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
      print('History Dispatch: $allDispatchJson');
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

}