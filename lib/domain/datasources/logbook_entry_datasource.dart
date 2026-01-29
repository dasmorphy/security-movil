
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

abstract class LogbookEntryDatasource {
  Future<List<Category>> getAllCategory();
  Future<List<UnityWeight>> getAllUnityWeight();
  Future<bool> saveLogbookEntry(Map<String, dynamic> data);
  Future<bool> saveLogbookOut(Map<String, dynamic> data);
  Future <List<Map<String, dynamic>>> getHistoryLogbooks();
  Future<void> downloadExcel();
}