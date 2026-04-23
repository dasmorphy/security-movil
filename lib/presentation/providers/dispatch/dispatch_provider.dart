import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/domain/entities/dispatch_status.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';
import 'package:zentinel/domain/repositories/dispatch_repository.dart';
import 'package:zentinel/presentation/providers/dispatch/dispatch_repository_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';

final getAllDispatchProducts =
    StateNotifierProvider<CatalogNotifier<DispatchProducts>, List<DispatchProducts>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);

  return CatalogNotifier<DispatchProducts>(
    (_) => repo.getAllDispatchProducts(),
  );
});

final getAreasVisit =
    StateNotifierProvider<CatalogNotifier<Map<dynamic, dynamic>>, List<Map<dynamic, dynamic>>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);

  return CatalogNotifier<Map<dynamic, dynamic>>(
    (_) => repo.getAreasVisit(),
  );
});

final getMaterials =
    StateNotifierProvider<CatalogNotifier<Map<dynamic, dynamic>>, List<Map<dynamic, dynamic>>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);

  return CatalogNotifier<Map<dynamic, dynamic>>(
    (_) => repo.getMaterials(),
  );
});

final getStaffCharge =
    StateNotifierProvider<CatalogNotifier<Map<dynamic, dynamic>>, List<Map<dynamic, dynamic>>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);

  return CatalogNotifier<Map<dynamic, dynamic>>(
    (_) => repo.getStaffCharge(),
  );
});

final getDispatchStatus =
    StateNotifierProvider<CatalogNotifier<DispatchStatus>, List<DispatchStatus>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);

  return CatalogNotifier<DispatchStatus>(
    (_) => repo.getDispatchStatus(),
  );
});

final dispatchProvider =
    StateNotifierProvider<DispatchProvider, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);
  return DispatchProvider(repo);
});

final graphDispatchProvider = FutureProvider<GraphDispatch>((ref) async {
  final repo = ref.watch(dispatchRepositoryProvider);
  return await repo.getGraphDispatch();
});


final getHistoryDispatch =
    StateNotifierProvider<
        CatalogNotifier<AllDispatch>,
        List<AllDispatch>>(
  (ref) {
    final repo = ref.watch(dispatchRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return CatalogNotifier<AllDispatch>((_) async => []);
    }

    final userData = authState.value!;
    
    return CatalogNotifier<AllDispatch>(
      (filters) {
        final mergedFilters = {
          if (userData.role == 'admin' || userData.role == 'admin_tlsg')
            'id_business': userData.attributes['id_business']
          else
            'user': userData.user,
          ...?filters,
        };
        return repo.getHistoryDispatch(mergedFilters);
      },
    );
  },
);

final getHistoryEntryAccess =
    StateNotifierProvider<
        CatalogNotifier<EntryAccessControl>,
        List<EntryAccessControl>>(
  (ref) {
    final repo = ref.watch(dispatchRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return CatalogNotifier<EntryAccessControl>((_) async => []);
    }

    final userData = authState.value!;

    return CatalogNotifier<EntryAccessControl>(
      (filters) {
        final mergedFilters = {
          if (userData.role == 'admin' || userData.role == 'admin_tlsg')
            'id_business': userData.attributes['id_business']
          else
            'user': userData.user,
          ...?filters,
        };
        return repo.getHistoryEntryAccess(mergedFilters);
      },
    );
  },
);

class DispatchProvider extends StateNotifier<AsyncValue<ApiResponse>> {
  final DispatchRepository repository;

  DispatchProvider(this.repository)
      : super(AsyncData(ApiResponse(success: false)));

  Future<ApiResponse> saveDispatch(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveDispatch(data);
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

  Future<ApiResponse> updateDispatch(Map<String, dynamic> data) async {
    state = const AsyncLoading();

    try {
      final response = await repository.updateDispatch(data);

      state = AsyncData(response);

      return response;
    } catch (e, st) {
      state = AsyncError(e, st);

      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> saveReception(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveReception(data);
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

  Future<ApiResponse> saveEntry(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveEntry(data);
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

  Future<ApiResponse> updateEntry(Map<String, dynamic> data) async {
    state = const AsyncLoading();

    try {
      final response = await repository.updateEntry(data);

      state = AsyncData(response);

      return response;
    } catch (e, st) {
      state = AsyncError(e, st);

      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

}