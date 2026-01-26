import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/domain/repositories/logbook_entry_repository.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_repository_provider.dart';

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
    StateNotifierProvider<DepatureReportNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return DepatureReportNotifier(repo);
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

class DepatureReportNotifier extends StateNotifier<AsyncValue<void>> {
  final LogbookEntryRepository repository;

  DepatureReportNotifier(this.repository)
      : super(const AsyncData(null));

  Future<void> saveLogbookEntry(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    print("saveLogbookEntry");
    print(data);
    try {
      await repository.saveLogbookEntry(data);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

