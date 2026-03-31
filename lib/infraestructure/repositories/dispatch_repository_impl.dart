import 'package:zentinel/domain/datasources/dispatch_datasource.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';
import 'package:zentinel/domain/repositories/dispatch_repository.dart';

class DispatchRepositoryImpl extends DispatchRepository {
  final DispatchDatasource datasource;
  DispatchRepositoryImpl(this.datasource);


  @override
  Future<List<DispatchProducts>> getAllDispatchProducts() {
    return datasource.getAllDispatchProducts();
  }

  @override
  Future<ApiResponse> saveDispatch(Map<String, dynamic> data) {
    return datasource.saveDispatch(data);
  }

  @override
  Future<List<VehicleType>> getAllVehicleTypes() {
    return datasource.getAllVehicleTypes();
  }

  @override
  Future<List<AllDispatch>> getHistoryDispatch(Map<String, dynamic> filters) {
    return datasource.getHistoryDispatch(filters);
  }

  @override
  Future<ApiResponse<dynamic>> updateDispatch(Map<String, dynamic> data) {
    return datasource.updateDispatch(data);
  }
}