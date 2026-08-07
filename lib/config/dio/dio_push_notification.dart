import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/interceptor/dio_interceptor.dart';

final dioPushNotificationProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.notificationUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Agregar el interceptor que maneja el token JWT
  dio.interceptors.add(DioInterceptor(ref));

  return dio;
});
