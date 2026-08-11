import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zentinel/config/router/notification_router.dart';


/// Handler para mensajes recibidos en background.
/// Debe ser una función top-level o estática (requisito de Firebase).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Este isolate no comparte estado con el main isolate:
  // hay que inicializar Firebase y el plugin local aquí también.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final localNotifications = FlutterLocalNotificationsPlugin();
  await localNotifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  // Si viene "notification" úsalo; si es data-only, cae a message.data.
  final title = message.notification?.title ?? message.data['title'];
  final body = message.notification?.body ?? message.data['body'];

  if (title == null && body == null) return;

  await localNotifications.show(
    id: message.hashCode,
    title: title,
    body: body,
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

class PushNotificationProvider {
  PushNotificationProvider._internal();
  static final PushNotificationProvider instance =
      PushNotificationProvider._internal();

  static const String _fcmTokenKey = 'fcm_token';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Se invoca cuando Firebase rota el token, para reenviarlo al backend.
  /// Se asigna desde la app porque este singleton se inicializa en main(),
  /// antes de que exista el ProviderScope.
  Future<void> Function(String token)? onTokenRefreshed;

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
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('Token FCM renovado: $newToken');
      await _saveFcmToken(newToken);
      await onTokenRefreshed?.call(newToken);
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
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
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
    try {
      final notification = message.notification;
      if (notification == null) return;

      // Se conserva toda la data y se garantizan las claves que usa el
      // despachador de navegación (NotificationRouter.navigateFromData).
      final payload = <String, dynamic>{
        ...message.data,
        'notification_type': message.data['notification_type'],
        'history_id': message.data['history_id'],
      };

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
        payload: jsonEncode(payload),
      );
    }catch (e) {
      print('Error al manejar mensaje en foreground: $e');
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notificación abierta con data: ${message.data}');
    // Despacha la navegación según el notification_type del payload.
    NotificationRouter.navigateFromData(message.data);
  }

  /// Se dispara al tocar una notificación local (ej. mostrada en foreground).
  /// El payload es el `jsonEncode(message.data)` guardado al mostrarla.
  void _onLocalNotificationTapped(NotificationResponse details) {
    final payload = details.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      NotificationRouter.navigateFromData(data);
    } catch (e) {
      print('Error al procesar payload de notificación local: $e');
    }
  }

  Future<void> _fetchAndSaveToken() async {
    try {
      final token = await _firebaseMessaging.getToken();

      print('Token FCM: $token');


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

  /// Plataforma tal como la espera el backend.
  String get platform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
      default:
        return 'android';
    }
  }

  /// Devuelve el token guardado y, si aún no existe, lo pide a Firebase.
  Future<String?> resolveFcmToken() async {
    final saved = await getSavedFcmToken();
    if (saved != null && saved.isNotEmpty) return saved;

    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _saveFcmToken(token);
    }
    return token;
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);
  }
}
