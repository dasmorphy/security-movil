import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/datasources/dispatch_datasource.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
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
  Future<bool> saveDispatch(Map<String, dynamic> data) async {
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

      return response.statusCode == 200; // Retorna true si la respuesta es exitosa
    } catch (e) {
      print('Error al guardar el dispatch: $e');
      return false; // Retorna false en caso de error
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

}