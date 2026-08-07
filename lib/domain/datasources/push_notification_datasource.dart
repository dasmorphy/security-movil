

import 'package:zentinel/domain/entities/notification_push.dart';

abstract class PushNotificationDatasource {
  Future<List<NotificationPush>> getNotifications(Map<String, dynamic> filters);
}