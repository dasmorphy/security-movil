import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/repositories/round_repository.dart';
import 'package:zentinel/presentation/providers/round/round_repository_provider.dart';


final roundProvider =
    StateNotifierProvider<RoundProvider, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(roundRepositoryProvider);
  return RoundProvider(repo);
});


class RoundProvider extends StateNotifier<AsyncValue<ApiResponse>> {
  final RoundRepository repository;

  RoundProvider(this.repository)
      : super(AsyncData(ApiResponse(success: false)));

  Future<ApiResponse> saveRound(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveRound(data);
      state = AsyncData(response);
      return response;
    } catch (e, st) {
      print('Error out E, $e');
      print('Error out ST, $st');
      state = AsyncError(e, st);
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}