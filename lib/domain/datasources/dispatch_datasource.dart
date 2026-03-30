import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';

abstract class DispatchDatasource {
  Future<List<DispatchProducts>> getAllDispatchProducts();
  Future<bool> saveDispatch(Map<String, dynamic> data);
  Future<List<VehicleType>> getAllVehicleTypes();

}