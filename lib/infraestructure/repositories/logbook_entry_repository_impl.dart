import 'package:zentinel/domain/datasources/logbook_entry_datasource.dart';
import 'package:zentinel/domain/entities/category.dart';
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
    print("saveLogbookEntry repository impl");
    print(data);
    return datasource.saveLogbookEntry(data);
  }
  
  @override
  Future<bool> saveLogbookOut(Map<String, dynamic> data) {
    print("saveLogbookEntry repository impl");
    print(data);
    return datasource.saveLogbookOut(data);
  }
  
}