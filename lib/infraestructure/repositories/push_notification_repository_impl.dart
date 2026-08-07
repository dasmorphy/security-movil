import 'package:zentinel/domain/datasources/push_notification_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/notification_push.dart';
import 'package:zentinel/domain/repositories/push_notification_repository.dart';

class PushNotificationRepositoryImpl extends PushNotificationRepository {

  final PushNotificationDatasource datasource;
  PushNotificationRepositoryImpl(this.datasource);

  @override
  Future<List<NotificationPush>> getNotifications(Map<String, dynamic> filters) {
    return datasource.getNotifications(filters);
  }

  @override
  Future<ApiResponse<dynamic>> saveFcmTokenUser(Map<String, dynamic> data) {
    return datasource.saveFcmTokenUser(data);
  }
}