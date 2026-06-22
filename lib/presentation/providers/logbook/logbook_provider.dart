import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/data/models/hive/category_model.dart';
import 'package:zentinel/data/models/hive/authorized_model.dart';
import 'package:zentinel/data/models/hive/destiny_intern_model.dart';
import 'package:zentinel/data/models/hive/unity_weight_model.dart';
import 'package:zentinel/data/models/hive/vehicle_type_model.dart';
import 'package:zentinel/data/models/hive/group_business_model.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/authorized.dart';
import 'package:zentinel/domain/entities/category.dart';
import 'package:zentinel/domain/entities/destiny_intern.dart';
import 'package:zentinel/domain/entities/employee_intern.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/domain/entities/graph_logbook.dart';
import 'package:zentinel/domain/entities/group_business.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';
import 'package:zentinel/domain/repositories/logbook_entry_repository.dart';
import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
import 'package:zentinel/presentation/providers/catalog_notifier.dart';
import 'package:zentinel/presentation/providers/dispatch/dispatch_repository_provider.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_repository_provider.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

final getAllCategories =
    StateNotifierProvider<CatalogNotifierWithCache<Category>, List<Category>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return CatalogNotifierWithCache<Category>(
    fetch: (_) async {
      final categories = await repo.getAllCategory();
      // Convertir a modelos Hive y guardar
      final categoryModels = categories
          .map((c) => CategoryModel.fromEntity(
                c.idCategory,
                c.nameCategory,
                c.createdAt,
                c.updatedAt,
              ))
          .toList();
      await hiveService.saveCategories(categoryModels);
      return categories;
    },
    cacheGetter: () {
      final cachedModels = hiveService.getCategories();
      return cachedModels
          .map((model) => Category(
                idCategory: model.idCategory,
                nameCategory: model.nameCategory,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
              ))
          .toList();
    },
    cacheSaver: (categories) async {
      final categoryModels = categories
          .map((c) => CategoryModel.fromEntity(
                c.idCategory,
                c.nameCategory,
                c.createdAt,
                c.updatedAt,
              ))
          .toList();
      await hiveService.saveCategories(categoryModels);
    },
    cacheChecker: () => hiveService.hasCategories(),
  );
});


final getAllUnitiesWeight =
    StateNotifierProvider<CatalogNotifierWithCache<UnityWeight>, List<UnityWeight>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return CatalogNotifierWithCache<UnityWeight>(
    fetch: (_) async {
      final unities = await repo.getAllUnitsWeight();
      final unityModels = unities
          .map((u) => UnityWeightModel.fromEntity(
                u.idUnity,
                u.name,
                u.code,
                u.createdAt,
                u.updatedAt,
              ))
          .toList();
      await hiveService.saveUnityWeight(unityModels);
      return unities;
    },
    cacheGetter: () {
      final cachedModels = hiveService.getUnityWeight();
      return cachedModels
          .map((model) => UnityWeight(
                idUnity: model.id,
                name: model.name,
                code: model.code,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
              ))
          .toList();
    },
    cacheSaver: (unities) async {
      final unityModels = unities
          .map((u) => UnityWeightModel.fromEntity(
                u.idUnity,
                u.name,
                u.code,
                u.createdAt,
                u.updatedAt,
              ))
          .toList();
      await hiveService.saveUnityWeight(unityModels);
    },
    cacheChecker: () => hiveService.hasUnityWeight(),
  );
});

final getAllVehicleTypes =
    StateNotifierProvider<CatalogNotifierWithCache<VehicleType>, List<VehicleType>>((ref) {
  final repo = ref.watch(dispatchRepositoryProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return CatalogNotifierWithCache<VehicleType>(
    fetch: (_) async {
      final vehicleTypes = await repo.getAllVehicleTypes();
      final vehicleModels = vehicleTypes
          .map((v) => VehicleTypeModel.fromEntity(
                v.idVehicleType,
                v.name,
                v.createdAt.toIso8601String(),
                v.updatedAt.toIso8601String(),
                v.createdBy,
                v.updatedBy,
              ))
          .toList();
      await hiveService.saveVehicleType(vehicleModels);
      return vehicleTypes;
    },
    cacheGetter: () {
      final cachedModels = hiveService.getVehicleType();
      return cachedModels
          .map((model) => VehicleType(
                idVehicleType: model.idVehicleType,
                name: model.name,
                createdAt: DateTime.parse(model.createdAt),
                updatedAt: DateTime.parse(model.updatedAt),
                createdBy: model.createdBy,
                updatedBy: model.updatedBy,
              ))
          .toList();
    },
    cacheSaver: (vehicleTypes) async {
      final vehicleModels = vehicleTypes
          .map((v) => VehicleTypeModel.fromEntity(
                v.idVehicleType,
                v.name,
                v.createdAt.toIso8601String(),
                v.updatedAt.toIso8601String(),
                v.createdBy,
                v.updatedBy,
              ))
          .toList();
      await hiveService.saveVehicleType(vehicleModels);
    },
    cacheChecker: () => hiveService.hasVehicleType(),
  );
});

final getAllAuthorized =
    StateNotifierProvider<CatalogNotifierWithCache<Authorized>, List<Authorized>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return CatalogNotifierWithCache<Authorized>(
    fetch: (_) async {
      final authorized = await repo.getAllAuthorized();
      final authorizedModels = authorized
          .map((a) => AuthorizedModel.fromEntity(
                a.idAuthorized,
                a.name,
                a.createdAt.toIso8601String(),
                a.updatedAt.toIso8601String(),
              ))
          .toList();
      await hiveService.saveAuthorized(authorizedModels);
      return authorized;
    },
    cacheGetter: () {
      final cachedModels = hiveService.getAuthorized();
      return cachedModels
          .map((model) => Authorized(
                idAuthorized: model.idAuthorized,
                name: model.name,
                createdAt: DateTime.parse(model.createdAt),
                updatedAt: DateTime.parse(model.updatedAt),
              ))
          .toList();
    },
    cacheSaver: (authorized) async {
      final authorizedModels = authorized
          .map((a) => AuthorizedModel.fromEntity(
                a.idAuthorized,
                a.name,
                a.createdAt.toIso8601String(),
                a.updatedAt.toIso8601String(),
              ))
          .toList();
      await hiveService.saveAuthorized(authorizedModels);
    },
    cacheChecker: () => hiveService.hasAuthorized(),
  );
});

final getAllDestinyIntern = StateNotifierProvider<CatalogNotifierWithCache<DestinyIntern>, List<DestinyIntern>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  final authState = ref.watch(userSessionProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  if (!authState.hasValue || authState.value == null) {
    return CatalogNotifierWithCache<DestinyIntern>(
      fetch: (_) async => [],
      cacheGetter: () => [],
      cacheSaver: (_) async {},
      cacheChecker: () => false,
    );
  }

  final userData = authState.value!;

  return CatalogNotifierWithCache<DestinyIntern>(
    fetch: (filters) async {
      final mergedFilters = {
        'business': 2
      };
      final destinyIntern = await repo.getAllDestinyIntern(mergedFilters);
      final destinyModels = destinyIntern
          .map((d) => DestinyInternModel.fromEntity(
                d.idDestiny,
                d.name,
                d.createdAt.toIso8601String(),
                d.updatedAt.toIso8601String(),
              ))
          .toList();
      await hiveService.saveDestinyIntern(destinyModels);
      return destinyIntern;
    },
    cacheGetter: () {
      final cachedModels = hiveService.getDestinyIntern();
      return cachedModels
          .map((model) => DestinyIntern(
                idDestiny: model.idDestiny,
                name: model.name,
                createdAt: DateTime.parse(model.createdAt),
                updatedAt: DateTime.parse(model.updatedAt),
              ))
          .toList();
    },
    cacheSaver: (destinyIntern) async {
      final destinyModels = destinyIntern
          .map((d) => DestinyInternModel.fromEntity(
                d.idDestiny,
                d.name,
                d.createdAt.toIso8601String(),
                d.updatedAt.toIso8601String(),
              ))
          .toList();
      await hiveService.saveDestinyIntern(destinyModels);
    },
    cacheChecker: () => hiveService.hasDestinyIntern(),
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

final saveEmployeeInternProvider =
    StateNotifierProvider<FetchApiResponse, AsyncValue<ApiResponse<dynamic>>>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);
  return FetchApiResponse(repo);
});

final graphLogbookProvider =
    StateNotifierProvider<ObjectCatalogNotifier<GraphLogbook>, GraphLogbook?>((ref) {
  final repo = ref.watch(logbookEntryRepositoryProvider);

  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, now.day);
  final endDate = startDate.add(const Duration(days: 1));

  return ObjectCatalogNotifier<GraphLogbook>(
    (filters) {
      final mergedFilters = {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      };
      return repo.getGraphLogbook(mergedFilters);
    }
  );
});

final getHistoryLogbooks =
    StateNotifierProvider<
        CatalogNotifier<AllLogbook>,
        List<AllLogbook>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return CatalogNotifier<AllLogbook>((_) async => []);
    }

    final userData = authState.value!;

    return CatalogNotifier<AllLogbook>(
      (filters) {
        final mergedFilters = {
          if (userData.hasPermission(Permissions.dataGroupBusiness))
            'groups_business_id': userData.attributes['group_business'],

          if (userData.role == 'admin' || userData.role == 'admin_tlsg')
            'id_business': userData.attributes['id_business'],
          if (userData.role == 'guardia')
            'user': userData.user,
            
          ...?filters,
        };
        return repo.getHistoryLogbooks(mergedFilters);
      },
    );
  },
);

final getEmployeeInterns =
    StateNotifierProvider<
        CatalogNotifier<EmployeeIntern>,
        List<EmployeeIntern>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);

    return CatalogNotifier<EmployeeIntern>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getEmployeeInterns(mergedFilters);
      },
    );
  },
);

final getEmployeeInternById =
    StateNotifierProvider<
        CatalogNotifier<EmployeeIntern>,
        List<EmployeeIntern>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);

    return CatalogNotifier<EmployeeIntern>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getEmployeeInterns(mergedFilters);
      },
    );
  },
);

final getEmployeeMovements =
    StateNotifierProvider<
        CatalogNotifier<EmployeeMovement>,
        List<EmployeeMovement>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);

    return CatalogNotifier<EmployeeMovement>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getEmployeeMovements(mergedFilters);
      },
    );
  },
);

final getEmployeeMovementsById =
    StateNotifierProvider<
        CatalogNotifier<EmployeeMovement>,
        List<EmployeeMovement>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);

    return CatalogNotifier<EmployeeMovement>(
      (filters) {
        final mergedFilters = {
          ...?filters,
        };
        return repo.getEmployeeMovements(mergedFilters);
      },
    );
  },
);


final getGroupBusinessByIdBusiness =
    StateNotifierProvider<CatalogNotifierWithCache<GroupBusiness>, List<GroupBusiness>>(
  (ref) {
    final repo = ref.watch(logbookEntryRepositoryProvider);
    final authState = ref.watch(userSessionProvider);
    final hiveService = ref.watch(hiveServiceProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      throw Exception('Usuario no esta en sesión');
    }

    final userData = authState.value!;

    return CatalogNotifierWithCache<GroupBusiness>(
      fetch: (filters) async {
        final idBusiness = userData.attributes['id_business'] ?? 0;
        final groupBusiness = await repo.getGroupBusinessByIdBusiness(idBusiness);
        final businessModels = groupBusiness
            .map((g) => GroupBusinessModel.fromEntity(
                  g.idGroupBusiness,
                  g.name,
                  g.businessId,
                  g.sectorId,
                  g.createdAt.toIso8601String(),
                  g.updatedAt.toIso8601String(),
                ))
            .toList();
        await hiveService.saveGroupBusiness(businessModels);
        return groupBusiness;
      },
      cacheGetter: () {
        final cachedModels = hiveService.getGroupBusiness();
        return cachedModels
            .map((model) => GroupBusiness(
                  idGroupBusiness: model.idGroupBusiness,
                  name: model.name,
                  businessId: model.businessId,
                  sectorId: model.sectorId,
                  createdAt: DateTime.parse(model.createdAt),
                  updatedAt: DateTime.parse(model.updatedAt),
                ))
            .toList();
      },
      cacheSaver: (groupBusiness) async {
        final businessModels = groupBusiness
            .map((g) => GroupBusinessModel.fromEntity(
                  g.idGroupBusiness,
                  g.name,
                  g.businessId,
                  g.sectorId,
                  g.createdAt.toIso8601String(),
                  g.updatedAt.toIso8601String(),
                ))
            .toList();
        await hiveService.saveGroupBusiness(businessModels);
      },
      cacheChecker: () => hiveService.hasGroupBusiness(),
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

class FetchApiResponse extends StateNotifier<AsyncValue<ApiResponse>> {
  final LogbookEntryRepository repository;
  FetchApiResponse(this.repository) : super(AsyncData(ApiResponse(success: false)));

  Future<ApiResponse> saveEmployeeIntern(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveEmployeeIntern(data);
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

  Future<ApiResponse> updateStatusEmployeeIntern(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.updateStatusEmployeeIntern(data);
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

  Future<ApiResponse> saveEmployeeMovement(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveEmployeeMovement(data);
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

class ReportDownloadNotifier extends StateNotifier<void> {
  final LogbookEntryRepository repository;

  ReportDownloadNotifier(this.repository)
      : super(const AsyncData(false));

  Future<void> downloadReport() async {
    await repository.downloadExcel();
  }
}
