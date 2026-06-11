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
import 'package:zentinel/domain/repositories/logbook_entry_repository.dart';

class LogbookEntryRepositoryImpl extends LogbookEntryRepository {

  final LogbookEntryDatasource datasource;
  LogbookEntryRepositoryImpl(this.datasource);


  @override
  Future<List<Category>> getAllCategory() {
    return datasource.getAllCategory();
  }

  @override
  Future<List<UnityWeight>> getAllUnitsWeight() {
    return datasource.getAllUnityWeight();
  }
  
  @override
  Future<bool> saveLogbookEntry(Map<String, dynamic> data) {
    return datasource.saveLogbookEntry(data);
  }
  
  @override
  Future<bool> saveLogbookOut(Map<String, dynamic> data) {
    return datasource.saveLogbookOut(data);
  }
  
  @override
  Future <List<AllLogbook>> getHistoryLogbooks(Map<String, dynamic> filters) {
    return datasource.getHistoryLogbooks(filters);
  }
  
  @override
  Future<void> downloadExcel() {
    return datasource.downloadExcel();
  }
  
  @override
  Future<List<GroupBusiness>> getGroupBusinessByIdBusiness(int idBusinness) {
    return datasource.getGroupBusinessByIdBusiness(idBusinness);
  }

  @override
  Future<List<Authorized>> getAllAuthorized() {
    return datasource.getAllAuthorized();
  }

  @override
  Future<List<DestinyIntern>> getAllDestinyIntern(Map<String, dynamic> filters) {
    return datasource.getAllDestinyIntern(filters);
  }

  @override
  Future<GraphLogbook> getGraphLogbook(Map<String, dynamic> filters) {
    return datasource.getGraphLogbook(filters);
  }
  
  @override
  Future<ApiResponse<dynamic>> saveEmployeeIntern(Map<String, dynamic> data) {
    return datasource.saveEmployeeIntern(data);
  }

  @override
  Future<ApiResponse<dynamic>> saveEmployeeMovement(Map<String, dynamic> data) {
    return datasource.saveEmployeeMovement(data);
  }
  
  @override
  Future<List<EmployeeIntern>> getEmployeeInterns(Map<String, dynamic> filters) {
    return datasource.getEmployeeInterns(filters);
  }

  @override
  Future<List<EmployeeMovement>> getEmployeeMovements(Map<String, dynamic> filters) {
    return datasource.getEmployeeMovements(filters);
  }
  
  @override
  Future<ApiResponse<dynamic>> updateStatusEmployeeIntern(Map<String, dynamic> data) {
    return datasource.updateStatusEmployeeIntern(data);
  }
  
}