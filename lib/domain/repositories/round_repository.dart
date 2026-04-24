import 'package:zentinel/domain/entities/api_response.dart';

abstract class RoundRepository {
  Future<ApiResponse> saveRound(Map<String, dynamic> data);
}