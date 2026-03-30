import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/repositories/dispatch_repository.dart';

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