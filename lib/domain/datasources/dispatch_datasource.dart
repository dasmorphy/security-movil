import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';

abstract class DispatchDatasource {
  Future<List<DispatchProducts>> getAllDispatchProducts();
  Future<ApiResponse> saveDispatch(Map<String, dynamic> data);
  Future<List<VehicleType>> getAllVehicleTypes();
  Future <List<AllDispatch>> getHistoryDispatch(Map<String, dynamic> filters);
  Future<ApiResponse<dynamic>> updateDispatch(Map<String, dynamic> data);
}