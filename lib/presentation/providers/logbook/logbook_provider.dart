import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/domain/repositories/logbook_entry_repository.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_repository_provider.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

final getAllCategories =
    StateNotifierProvider<CatalogNotifier<Category>, List<Category>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);

  return CatalogNotifier<Category>(
    (_) => repo.getAllCategory(),
  );
});


final getAllUnitiesWeight =
    StateNotifierProvider<CatalogNotifier<UnityWeight>, List<UnityWeight>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);

  return CatalogNotifier<UnityWeight>(
    (_) => repo.getAllUnitsWeight(),
  );
});


final saveDepatureReportProvider =
    StateNotifierProvider<DepatureReportNotifier, AsyncValue<bool>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return DepatureReportNotifier(repo);
});

final saveOutLogbookProvider =
    StateNotifierProvider<OutLogbookNotifier, AsyncValue<bool>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return OutLogbookNotifier(repo);
});


final getHistoryLogbooks =
    StateNotifierProvider.autoDispose<
        CatalogNotifier<Map<String, dynamic>>,
        List<Map<String, dynamic>>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return CatalogNotifier<Map<String, dynamic>>((_) async => []);
    }

    final userData = authState.value!;

    return CatalogNotifier<Map<String, dynamic>>(
      (filters) {
        final mergedFilters = {
          if (userData.role == 'admin')
            'id_business': userData.attributes['id_business']
          else
            'user': userData.user,
          ...?filters,
        };
        return repo.getHistoryLogbooks(mergedFilters);
      },
    );
  },
);


final getGroupBusinessByIdBusiness =
    StateNotifierProvider<CatalogNotifier<GroupBusiness>, List<GroupBusiness>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      throw Exception('Usuario no esta en sesión');
    }

    final userData = authState.value!;

    return CatalogNotifier<GroupBusiness>(
      (filters) {
        final idBusiness = userData.attributes['id_business'] ?? 0;
        return repo.getGroupBusinessByIdBusiness(idBusiness);
      },
    );
  },
);


final downloadReport =
    StateNotifierProvider<ReportDownloadNotifier, void>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return ReportDownloadNotifier(repo);
});


typedef FetchListCallback<T> = Future<List<T>> Function(
  Map<String, dynamic>? filters,
);

class CatalogNotifier<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  bool _isLoading = false;

  CatalogNotifier(this.fetch) : super(const []);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      final data = await fetch(filters);

      if (!mounted) return; // 🔥 CLAVE

      state = data;
    } catch (e) {
      if (mounted) {
        state = [];
      }
    } finally {
      _isLoading = false;
    }
  }
}


class DepatureReportNotifier extends StateNotifier<AsyncValue<bool>> {
  final LogbookEntryRepository repository;

  DepatureReportNotifier(this.repository)
      : super(const AsyncData(false));

  Future<bool> saveLogbookEntry(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final success = await repository.saveLogbookEntry(data);
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      print('Error entry E, $e');
      print('Error entry ST, $st');
      state = AsyncError(e, st);
      return false;
    }
  }
}

class OutLogbookNotifier extends StateNotifier<AsyncValue<bool>> {
  final LogbookEntryRepository repository;

  OutLogbookNotifier(this.repository)
      : super(const AsyncData(false));

  Future<bool> saveLogbookOut(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final success = await repository.saveLogbookOut(data);
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


class ReportDownloadNotifier extends StateNotifier<void> {
  final LogbookEntryRepository repository;

  ReportDownloadNotifier(this.repository)
      : super(const AsyncData(false));

  Future<void> downloadReport() async {
    await repository.downloadExcel();
  }
}
