import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/category.dart';
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
    StateNotifierProvider<CatalogNotifier<Map<String, dynamic>>, List<Map<String, dynamic>>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    final userData = ref.watch(authProvider);

    return CatalogNotifier<Map<String, dynamic>>(
      (filters) {
        final mergedFilters = {
          // Solo agregar el filtro 'user' si el rol NO es admin
          if (userData['role'] != 'admin') 'user': userData['name'],
          ...?filters,
        };
        print("Fetching history logbooks with filters:");
        print(mergedFilters);
        print(userData);
        return repo.getHistoryLogbooks(mergedFilters);
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
    if (_isLoading) return;
    _isLoading = true;

    final data = await fetch(filters);
    state = data;

    _isLoading = false;
  }
}

class DepatureReportNotifier extends StateNotifier<AsyncValue<bool>> {
  final LogbookEntryRepository repository;

  DepatureReportNotifier(this.repository)
      : super(const AsyncData(false));

  Future<bool> saveLogbookEntry(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    print("saveLogbookEntry");
    print(data);
    try {
      final success = await repository.saveLogbookEntry(data);
      state = AsyncData(success);
      return success;
    } catch (e, st) {
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
    print("saveLogbookOut");
    print(data);
    try {
      final success = await repository.saveLogbookOut(data);
      state = AsyncData(success);
      return success;
    } catch (e, st) {
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
    print("downloadReport");
    // print(data);
    // try {
      await repository.downloadExcel();
    // } catch (e, st) {
    //   return false;
    // }
  }
}
