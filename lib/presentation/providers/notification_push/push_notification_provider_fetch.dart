import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/notification_push.dart';
import 'package:zentinel/domain/repositories/push_notification_repository.dart';
import 'package:zentinel/presentation/providers/catalog_notifier.dart';
import 'package:zentinel/presentation/providers/notification_push/push_notification_repository_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';

final getNotifications = StateNotifierProvider<CatalogNotifier<
  NotificationPush>, List<NotificationPush>
>((ref) {
  final repo = ref.watch(pushNotificationRepositoryProvider);

  final authState = ref.watch(userSessionProvider);

  if (!authState.hasValue || authState.value == null) {
    return CatalogNotifier<NotificationPush>((_) async => []);
  }

    final userData = authState.value!;

  return CatalogNotifier<NotificationPush>((filters) {
    final mergedFilters = {
      'id_user': userData.idUser,
      ...?filters,
    };
    return repo.getNotifications(mergedFilters);
  });
});

final pushNotificationFetchProvider =
    StateNotifierProvider<PushNotificationProviderFetch, AsyncValue<ApiResponse>>(
  (ref) {
    final repo = ref.watch(pushNotificationRepositoryProvider);
    return PushNotificationProviderFetch(repo);
  },
);

class PushNotificationProviderFetch extends StateNotifier<AsyncValue<ApiResponse>> {
  final PushNotificationRepository repository;

  PushNotificationProviderFetch(this.repository)
      : super(AsyncData(ApiResponse(success: false)));

  Future<ApiResponse> saveFcmTokenUser(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await repository.saveFcmTokenUser(data);
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
