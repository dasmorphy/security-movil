import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class DioInterceptor extends Interceptor {
  final Ref ref;

  DioInterceptor(this.ref);

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final showError = err.requestOptions.extra['showErrorMessage'] ?? true;

    if (showError) {
      final message =
          err.response?.data?['message'] ?? 'Error inesperado en el servidor';

      ref.read(globalMessageProvider.notifier).showError(message);
    }

    handler.next(err);
  }
}
