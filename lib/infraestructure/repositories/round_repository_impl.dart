import 'package:zentinel/domain/datasources/round_datasource.dart';
import 'package:zentinel/domain/entities/all_round.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/repositories/round_repository.dart';

class RoundRepositoryImpl extends RoundRepository {

  final RoundDatasource datasource;
  RoundRepositoryImpl(this.datasource);

  @override
  Future<ApiResponse<dynamic>> saveRound(Map<String, dynamic> data) {
    return datasource.saveRound(data);
  }
  
  @override
  Future<List<Map<dynamic, dynamic>>> getSectorPool() {
    return datasource.getSectorPool();
  }

  @override
  Future<List<AllRound>> getHistoryRounds(Map<String, dynamic> filters) {
    return datasource.getHistoryRounds(filters);
  }

}