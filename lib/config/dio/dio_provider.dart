import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/interceptor/dio_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // Agregar el interceptor que maneja el token JWT
  dio.interceptors.add(DioInterceptor(ref));

  return dio;
});

final dioLocalDevProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.localDevUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // Agregar el interceptor que maneja el token JWT
  dio.interceptors.add(DioInterceptor(ref));

  return dio;
});
