import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/domain/repositories/logbook_entry_repository.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_repository_provider.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

final getAllCategories =
    StateNotifierProvider<CatalogNotifier<Category>, List<Category>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return CatalogNotifier<Category>(repo.getAllCategory);
});

final getAllUnitiesWeight =
    StateNotifierProvider<CatalogNotifier<UnityWeight>, List<UnityWeight>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return CatalogNotifier<UnityWeight>(repo.getAllUnitsWeight);
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


final getHistoryLogbooks = StateNotifierProvider<CatalogNotifier<Map<String, dynamic>>, List<Map<String, dynamic>>>((ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    return CatalogNotifier<Map<String, dynamic>>(repo.getHistoryLogbooks);
});


final downloadReport =
    StateNotifierProvider<ReportDownloadNotifier, void>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return ReportDownloadNotifier(repo);
});


typedef FetchListCallback<T> = Future<List<T>> Function();

class CatalogNotifier<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  bool _isLoading = false;

  CatalogNotifier(this.fetch) : super(const []);

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;

    final data = await fetch();
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
