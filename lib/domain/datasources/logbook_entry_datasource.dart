
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/domain/entities/authorized.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/destiny_intern.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

abstract class LogbookEntryDatasource {
  Future<List<Category>> getAllCategory();
  Future<List<UnityWeight>> getAllUnityWeight();
  Future<bool> saveLogbookEntry(Map<String, dynamic> data);
  Future<bool> saveLogbookOut(Map<String, dynamic> data);
  Future <List<AllLogbook>> getHistoryLogbooks(Map<String, dynamic> filters);
  Future<void> downloadExcel();
  Future <List<GroupBusiness>> getGroupBusinessByIdBusiness(int idBusinness);
  Future <List<Authorized>> getAllAuthorized();
  Future <List<DestinyIntern>> getAllDestinyIntern();
}