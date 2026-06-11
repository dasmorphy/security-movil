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

abstract class LogbookEntryRepository {
  Future<List<Category>> getAllCategory();
  Future<List<UnityWeight>> getAllUnitsWeight();
  Future<bool> saveLogbookOut(Map<String, dynamic> data);
  Future<bool> saveLogbookEntry(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> saveEmployeeIntern(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> updateStatusEmployeeIntern(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> saveEmployeeMovement(Map<String, dynamic> data);
  Future <List<AllLogbook>> getHistoryLogbooks(Map<String, dynamic> filters);
  Future<void> downloadExcel();
  Future <List<GroupBusiness>> getGroupBusinessByIdBusiness(int idBusinness);
  Future <List<Authorized>> getAllAuthorized();
  Future <List<DestinyIntern>> getAllDestinyIntern(Map<String, dynamic> filters);
  Future <GraphLogbook> getGraphLogbook(Map<String, dynamic> filters);
  Future <List<EmployeeIntern>> getEmployeeInterns(Map<String, dynamic> filters);
  Future <List<EmployeeMovement>> getEmployeeMovements(Map<String, dynamic> filters);
}