// config/router/notification_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/domain/entities/notification_push.dart';
import 'package:zentinel/presentation/screens/screens.dart';
import 'package:zentinel/service/navigation_service.dart';

/// Rutas propias del modulo de notificaciones.
/// Se registran en [appRouter] con spread: `...notificationRoutes`.
/// Al agregar nuevos notification_type con pantalla propia, se declaran aqui.
final List<RouteBase> notificationRoutes = [
  GoRoute(
    path: '/notifications',
    name: PushNotificationsScreen.name,
    builder: (context, state) => const PushNotificationsScreen(),
  ),
  GoRoute(
    path: '/notification-history-detail',
    name: NotificationHistoryDetailScreen.name,
    builder: (context, state) {
      final historyId = state.extra as int;
      return NotificationHistoryDetailScreen(historyId: historyId);
    },
  ),
];

/// Despachador de navegacion segun el [NotificationPush.notificationType].
/// Centraliza el ruteo para escalar con nuevos tipos de notificacion.
class NotificationRouter {
  /// Navega desde un item ya cargado (ej. tap en la lista de notificaciones).
  static void navigate(BuildContext context, NotificationPush item) {
    _navigate(context, item.notificationType, item.data);
  }

  /// Navega desde el payload crudo de FCM (sin BuildContext propio).
  /// Usa el navigatorKey global del router y difiere al primer frame para
  /// cubrir el caso de app abierta desde estado terminado (cold start).
  static void navigateFromData(Map<String, dynamic> data) {
    final type = data['notification_type'] as String?;
    if (type == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) return;
      _navigate(context, type, data);
    });
  }

  /// Resuelve a donde navegar segun el tipo/data de la notificacion.
  static void _navigate(
    BuildContext context,
    String type,
    Map<String, dynamic> data,
  ) {
    switch (type) {
      case 'TECHNICAL_APPROVAL_REQUEST_REJECTED':
      case 'TECHNICAL_APPROVAL_REQUEST_APPROVED':
        final historyId = int.tryParse('${data['history_id']}');
        if (historyId == null) return;
        context.pushNamed(
          NotificationHistoryDetailScreen.name,
          extra: historyId,
        );
        break;
    }
  }
}