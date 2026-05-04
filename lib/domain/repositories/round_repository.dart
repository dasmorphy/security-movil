import 'package:zentinel/domain/entities/all_round.dart';
import 'package:zentinel/domain/entities/api_response.dart';

abstract class RoundRepository {
  Future<ApiResponse> saveRound(Map<String, dynamic> data);
  Future<List<Map<dynamic, dynamic>>> getSectorPool();
  Future <List<AllRound>> getHistoryRounds(Map<String, dynamic> filters);
}