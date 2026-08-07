import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/notification_push.dart';
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
