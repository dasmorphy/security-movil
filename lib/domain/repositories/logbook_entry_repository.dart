import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

abstract class LogbookEntryRepository {
  Future<List<Category>> getAllCategory();
  Future<List<UnityWeight>> getAllUnitsWeight();
  Future<bool> saveLogbookOut(Map<String, dynamic> data);
  Future<bool> saveLogbookEntry(Map<String, dynamic> data);
  Future <List<Map<String, dynamic>>> getHistoryLogbooks(Map<String, dynamic> filters);
  Future<void> downloadExcel();
  Future <List<GroupBusiness>> getGroupBusinessByIdBusiness(int idBusinness);
}