import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/domain/repositories/technical_repository.dart';
import 'package:zentinel/presentation/providers/catalog_notifier.dart';
import 'package:zentinel/presentation/providers/technical/technical_repository_provider.dart';

final getTaskTechnical =
    StateNotifierProvider<CatalogNotifier<TaskTechnical>, List<TaskTechnical>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<TaskTechnical>(
    (_) => repo.getTaskTechnical(),
  );
});

final getTechMaterial =
    StateNotifierProvider<CatalogNotifier<TechMaterial>, List<TechMaterial>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);
  return CatalogNotifier<TechMaterial>(
  (_) => repo.getTechMeterial(),
  );
});

final saveTechnicalRecordProvider =
    StateNotifierProvider<FetchTechnicalProvider, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);
  return FetchTechnicalProvider(repo);
});


class FetchTechnicalProvider extends StateNotifier<AsyncValue<ApiResponse>> {
  final TechnicalRepository repository;

  FetchTechnicalProvider(this.repository) : super(AsyncData(ApiResponse(success: false)));

  Future<ApiResponse> saveTechnicalRecord(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveTechnicalRecord(data);
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