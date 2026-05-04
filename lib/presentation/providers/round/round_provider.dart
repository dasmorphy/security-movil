import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/all_round.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/repositories/round_repository.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/providers/round/round_repository_provider.dart';


final roundProvider =
    StateNotifierProvider<RoundProvider, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(roundRepositoryProvider);
  return RoundProvider(repo);
});

final getSectorPool =
    StateNotifierProvider<CatalogNotifier<Map<dynamic, dynamic>>, List<Map<dynamic, dynamic>>>((ref) {
  final repo = ref.watch(roundRepositoryProvider);

  return CatalogNotifier<Map<dynamic, dynamic>>(
    (_) => repo.getSectorPool(),
  );
});

final getHistoryRounds =
    StateNotifierProvider<
        CatalogNotifier<AllRound>,
        List<AllRound>>(
  (ref) {
    final repo = ref.watch(roundRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return CatalogNotifier<AllRound>((_) async => []);
    }

    final userData = authState.value!;
    
    return CatalogNotifier<AllRound>(
      (filters) {
        final mergedFilters = {
          if (userData.role == 'admin' || userData.role == 'admin_tlsg')
            'id_business': userData.attributes['id_business']
          else
            'user': userData.user,
          ...?filters,
        };
        return repo.getHistoryRounds(mergedFilters);
      },
    );
  },
);


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