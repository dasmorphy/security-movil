import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';

abstract class DispatchRepository {
  Future<List<DispatchProducts>> getAllDispatchProducts();
  Future<List<VehicleType>> getAllVehicleTypes();
  Future<bool> saveDispatch(Map<String, dynamic> data);
}