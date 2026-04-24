import 'package:zentinel/domain/entities/api_response.dart';

abstract class RoundDatasource {
  Future<ApiResponse> saveRound(Map<String, dynamic> data);
}