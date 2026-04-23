import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/dispatch_status.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';

abstract class DispatchDatasource {
  Future<List<DispatchProducts>> getAllDispatchProducts();
  Future<ApiResponse> saveDispatch(Map<String, dynamic> data);
  Future<List<VehicleType>> getAllVehicleTypes();
  Future<List<DispatchStatus>> getDispatchStatus();
  Future<List<Map<dynamic, dynamic>>> getAreasVisit();
  Future<List<Map<dynamic, dynamic>>> getMaterials();
  Future<List<Map<dynamic, dynamic>>> getStaffCharge();
  Future <List<AllDispatch>> getHistoryDispatch(Map<String, dynamic> filters);
  Future <List<EntryAccessControl>> getHistoryEntryAccess(Map<String, dynamic> filters);
  Future<ApiResponse<dynamic>> updateDispatch(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> saveReception(Map<String, dynamic> data);
  Future<ApiResponse> saveEntry(Map<String, dynamic> data);
  Future<ApiResponse> updateEntry(Map<String, dynamic> data);
  Future<GraphDispatch> getGraphDispatch();
}