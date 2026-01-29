import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';

abstract class LogbookEntryRepository {
  Future<List<Category>> getAllCategory();
  Future<List<UnityWeight>> getAllUnitsWeight();
  Future<bool> saveLogbookEntry(Map<String, dynamic> data);
  Future<bool> saveLogbookOut(Map<String, dynamic> data);

}