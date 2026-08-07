

import 'package:zentinel/domain/entities/notification_push.dart';

abstract class PushNotificationRepository {
  Future<List<NotificationPush>> getNotifications(Map<String, dynamic> filters);
}