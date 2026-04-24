import 'package:zentinel/domain/datasources/round_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/repositories/round_repository.dart';

class RoundRepositoryImpl extends RoundRepository {

  final RoundDatasource datasource;
  RoundRepositoryImpl(this.datasource);

  @override
  Future<ApiResponse<dynamic>> saveRound(Map<String, dynamic> data) {
    return datasource.saveRound(data);
  }

}