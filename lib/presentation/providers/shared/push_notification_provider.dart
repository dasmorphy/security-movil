import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handler para mensajes recibidos en background.
/// Debe ser una función top-level o estática (requisito de Firebase).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Aquí NO se puede actualizar UI, solo procesar datos/logs.
  print('Mensaje en background: ${message.messageId}');
}

class PushNotificationProvider {
  PushNotificationProvider._internal();
  static final PushNotificationProvider instance =
      PushNotificationProvider._internal();

  static const String _fcmTokenKey = 'fcm_token';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializa todo el flujo: permisos, canal local, listeners y token.
  Future<void> initialize() async {
    await _requestPermissions();
    await _initLocalNotifications();

    // Handler para mensajes recibidos con la app en background.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Mensajes recibidos con la app abierta (foreground).
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Cuando el usuario toca la notificación y la app estaba en background.
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Si la app se abrió desde una notificación estando completamente cerrada.
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }

    await _fetchAndSaveToken();

    // Se actualiza si Firebase renueva el token.
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _saveFcmToken(newToken);
    });
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permiso de notificaciones: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notificación tocada con payload: ${details.payload}');
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notificaciones importantes',
      description: 'Canal usado para notificaciones push',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Notificaciones importantes',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    // Aquí puedes navegar según message.data, por ejemplo:
    // Navigator.pushNamed(context, message.data['route']);
    print('Notificación abierta con data: ${message.data}');
  }

  Future<void> _fetchAndSaveToken() async {
    try {
      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        await _saveFcmToken(token);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
    // Aquí podrías también enviar el token a tu backend.
  }

  Future<String?> getSavedFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);
  }
}
