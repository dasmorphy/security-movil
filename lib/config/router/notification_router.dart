// config/navigation/notification_router.dart
import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/notification_push.dart';

class NotificationRouter {
  /// Resuelve a dónde navegar según el tipo/data de la notificación.
  static void navigate(BuildContext context, NotificationPush item) {
    
    switch (item.notificationType) {
      case 'TECHNICAL_APPROVAL_REQUEST_REJECTED':
      case 'TECHNICAL_APPROVAL_REQUEST_APPROVED':
        Navigator.of(context).pushNamed(
          '/notification-history-detail',
          arguments: {'historyId': item.data['history_id']},
        );
        break;
    }
  }
}