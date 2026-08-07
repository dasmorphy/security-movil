import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/datasources/push_notification_datasource.dart';
import 'package:zentinel/domain/entities/notification_push.dart';

class PushNotificationImpl extends PushNotificationDatasource {
  final Dio dio;

  PushNotificationImpl({required this.dio});
  final uuid = Uuid().v4();

  @override
  Future<List<NotificationPush>> getNotifications(filters) async {
    try {
      final response = await dio.get(
        '/rest/notifications-api/v1.0/notifications',
        queryParameters: {
          'id_user': filters['id_user']
        },
        options: Options(
          headers: {'externalTransactionId': uuid, 'channel': 'ZENTINEL'},
        ),
      );
      final List notificationsJson = response.data['data'];
      return notificationsJson.map((json) => NotificationPush.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

}