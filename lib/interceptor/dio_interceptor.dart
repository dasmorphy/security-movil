import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class DioInterceptor extends Interceptor {
  final Ref ref;
  bool isLoggingOut = false;

  DioInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains('/rest/zent-logbook-api/v1.0/post/login')) {
      return handler.next(options);
    }

    // Agregar el token JWT como header en todas las peticiones
    final userSession = ref.read(userSessionProvider);

    if (userSession.hasValue && userSession.value != null) {
      final token = userSession.value!.attributes['accessToken'] as String?;
      if (token != null && token.isNotEmpty) {
        options.headers['token'] = token;
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final showSuccess =
        response.requestOptions.extra['showSuccessMessage'] ?? false;

    if (showSuccess) {
      final data = response.data;

      if (data is Map && data['message'] != null) {
        ref.read(globalMessageProvider.notifier).showSuccess(data['message']);
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final showError = err.requestOptions.extra['showErrorMessage'] ?? true;
    final statusCode = err.response?.statusCode;
    
    if (err.requestOptions.path.contains('/rest/zent-logbook-api/v1.0/post/login')) {
      String message;
      
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Tiempo de espera agotado';
          break;

        case DioExceptionType.connectionError:
          message = 'Revise su conexión a internet';
          break;

        case DioExceptionType.badResponse:
          message = err.response?.data?['message'] ?? 'Error del servidor';
          break;

        default:
          message = 'Error inesperado';
      }

      ref.read(globalMessageProvider.notifier).showError(message);

      handler.next(err);
      return;
    }
    // Manejar error 401 (Unauthorized) - Token expirado o inválido
    if (err.response?.statusCode == 401 && !isLoggingOut) {
      isLoggingOut = true;

      try {
        final authState = ref.read(userSessionProvider);

        if (authState.hasValue && authState.value != null) {
          final userData = authState.value!;
          final hiveService = ref.read(hiveServiceProvider);
          await hiveService.deleteUserProfile(userData.email);
        }

        ref.invalidate(userProfileProvider);
        ref.invalidate(userNameProvider);

        await ref.read(userSessionProvider.notifier).logout();
        ref.invalidate(userSessionProvider);
      } finally {
        isLoggingOut = false;
      }

      handler.next(err);
      return;
    }

    if (showError && statusCode != 401) {
      String message;

      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Tiempo de espera agotado';
          break;

        case DioExceptionType.connectionError:
          message = 'Revise su conexión a internet';
          break;

        case DioExceptionType.badResponse:
          final data = err.response?.data;

          message = data is Map<String, dynamic>
            ? data['message'] ?? 'Error del servidor'
            : 'Error del servidor';

          break;

        default:
          message = 'Error inesperado';
      }

      ref.read(globalMessageProvider.notifier).showError(message);
    }

    handler.next(err);
  }
}
