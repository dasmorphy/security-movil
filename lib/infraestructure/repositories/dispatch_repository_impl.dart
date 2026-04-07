import 'package:zentinel/domain/datasources/dispatch_datasource.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/dispatch_status.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
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

  @override
  Future<List<DispatchStatus>> getDispatchStatus() {
    return datasource.getDispatchStatus();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveReception(Map<String, dynamic> data) {
    return datasource.saveReception(data);
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getAreasVisit() {
    return datasource.getAreasVisit();
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getMaterials() {
    return datasource.getMaterials();
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getStaffCharge() {
    return datasource.getStaffCharge();
  }
  
  @override
  Future<ApiResponse<dynamic>> saveEntry(Map<String, dynamic> data) {
    return datasource.saveEntry(data);
  }

  @override
  Future<List<EntryAccessControl>> getHistoryEntryAccess(Map<String, dynamic> filters) {
    return datasource.getHistoryEntryAccess(filters);
  }
}