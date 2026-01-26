import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_repository_provider.dart';


final getAllCategories = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  final fetchAllCategories = ref.watch(logbookEntryRepositoryProvider).getAllCategory;
  return CategoryNotifier(fetchAllCategories: fetchAllCategories);
});

typedef CatalogsCallback = Future<List<Category>> Function();

class CategoryNotifier extends StateNotifier<List<Category>> {
  CatalogsCallback fetchAllCategories;
  bool isLoading = false;

  CategoryNotifier({
    required this.fetchAllCategories
  }): super([]); //Se inicializa como un arreglo vacio

  Future<void> getAllCategories() async {
    if (isLoading) return;
    isLoading = true;
    final List<Category> categories = await fetchAllCategories();
    state = categories; //Al cambiar el valor de estado se notifica el cambio
    isLoading = false;
  }
}