import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/auditing_section.dart';
import 'package:zentinel/domain/entities/client_technical.dart';
import 'package:zentinel/domain/entities/graph_technical.dart';
import 'package:zentinel/domain/entities/history_status_project.dart';
import 'package:zentinel/domain/entities/location_technical.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/domain/entities/technical_staff.dart';
import 'package:zentinel/domain/repositories/technical_repository.dart';
import 'package:zentinel/presentation/providers/catalog_notifier.dart';
import 'package:zentinel/presentation/providers/technical/technical_repository_provider.dart';

final getTaskTechnical = StateNotifierProvider<CatalogNotifier<TaskTechnical>,
  List<TaskTechnical>>(
  (ref) {
    final repo = ref.watch(technicalRepositoryProvider);

    return CatalogNotifier<TaskTechnical>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getTaskTechnical(mergedFilters);
      },
    );
  },
);

final graphTechnicalProvider =
    StateNotifierProvider<ObjectCatalogNotifier<GraphTechnical>, GraphTechnical?>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);
  return ObjectCatalogNotifier<GraphTechnical>(
    (filters) => repo.getGraphTechnical({}),
  );
});

final getAuditingSections =
    StateNotifierProvider<CatalogNotifier<AuditingSection>, List<AuditingSection>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<AuditingSection>(
    (_) => repo.getAuditingSection(),
  );
});

final getTechMaterial =
    StateNotifierProvider<CatalogNotifier<TechMaterial>, List<TechMaterial>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);
  return CatalogNotifier<TechMaterial>(
  (_) => repo.getTechMeterial(),
  );
});

final technicalRecordProvider =
    StateNotifierProvider<FetchTechnicalProvider, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);
  return FetchTechnicalProvider(repo);
});

final getClientsTechnical =
    StateNotifierProvider<CatalogNotifier<ClientTechnical>, List<ClientTechnical>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<ClientTechnical>(
    (_) => repo.getClientsTechnical(),
  );
});


final getTechnicalStaff =
    StateNotifierProvider<CatalogNotifier<TechnicalStaff>, List<TechnicalStaff>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<TechnicalStaff>(
    (_) => repo.getTechnicalStaff(),
  );
});

final getTechnicalRecord = StateNotifierProvider<CatalogNotifier<TechnicalRecord>,
  List<TechnicalRecord>>(
  (ref) {
    final repo = ref.watch(technicalRepositoryProvider);

    return CatalogNotifier<TechnicalRecord>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getTechnicalRecord(mergedFilters);
      },
    );
  },
);


final getLocationTechnical =
    StateNotifierProvider.autoDispose<
        CatalogNotifier<LocationTechnical>,
        List<LocationTechnical>>(
  (ref) {
    final repo = ref.watch(technicalRepositoryProvider);

    return CatalogNotifier<LocationTechnical>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getLocationTechnical(mergedFilters);
      },
    );
  },
);

final getHistoryStatusProject =
    StateNotifierProvider.autoDispose<
        CatalogNotifier<HistoryStatusProject>,
        List<HistoryStatusProject>>(
  (ref) {
    final repo = ref.watch(technicalRepositoryProvider);

    return CatalogNotifier<HistoryStatusProject>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getHistoryStatusProject(mergedFilters);
      },
    );
  },
);

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

  Future<ApiResponse> patchTechnicalRecord(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.patchTechnicalRecord(data);
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

  Future<ApiResponse> saveAuditing(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveAuditing(data);
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

  Future<ApiResponse> saveProduct(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveProduct(data);
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

  Future<ApiResponse> saveProjectTechnical(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveProjectTechnical(data);
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

  Future<ApiResponse> updateStatusProject(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.updateStatusProject(data);
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

  Future<ApiResponse> saveLocationClient(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveLocationClient(data);
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