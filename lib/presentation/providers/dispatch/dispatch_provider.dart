import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/repositories/dispatch_repository.dart';
import 'package:zentinel/presentation/providers/dispatch/dispatch_repository_provider.dart';


final saveDispatchProvider =
    StateNotifierProvider<DispatchProvider, AsyncValue<bool>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);
  return DispatchProvider(repo);
});

class DispatchProvider extends StateNotifier<AsyncValue<bool>> {
  final DispatchRepository repository;

  DispatchProvider(this.repository)
      : super(const AsyncData(false));

  Future<bool> saveDispatch(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final success = await repository.saveDispatch(data);
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      print('Error out E, $e');
      print('Error out ST, $st');
      state = AsyncError(e, st);
      return false;
    }
  }
}