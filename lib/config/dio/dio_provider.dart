import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/constants/environment.dart';
import 'package:zentinel/interceptor/dio_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environments.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(DioInterceptor(ref));

  return dio;
});
