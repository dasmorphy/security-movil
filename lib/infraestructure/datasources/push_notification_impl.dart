import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/push_notification_datasource.dart';
import 'package:zentinel/domain/entities/api_response.dart';
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

  @override
  Future<ApiResponse<dynamic>> saveFcmTokenUser(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '/rest/notifications-api/v1.0/fcm-token-user',
        data: {
          'externalTransactionId': uuid, 
          'channel': 'ZENTINEL',
          'data': data
        },
        options: onlyError(),
      );

      final body = response.data;

      return ApiResponse(
        success: response.statusCode == 200,
        errorCode: body['error_code']?.toString(),
        message: body['message'],
        data: body['data'],
      );
    } catch (e) {
      print('Error al guardar token: $e');
      String messageError = "Error al guardar token";
      if (e is DioException) {
        messageError = e.response?.data["message"];
      }
      return ApiResponse(
        success: false,
        errorCode: 'save_error',
        message: messageError,
      );
    }
  }

}