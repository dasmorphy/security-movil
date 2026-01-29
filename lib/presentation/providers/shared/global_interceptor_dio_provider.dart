import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalInterceptorDioProvider {
  final String text;
  final bool isError;

  GlobalInterceptorDioProvider(this.text, {this.isError = false});
}

final globalMessageProvider =
    StateNotifierProvider<GlobalMessageNotifier, GlobalInterceptorDioProvider?>(
  (ref) => GlobalMessageNotifier(),
);

class GlobalMessageNotifier extends StateNotifier<GlobalInterceptorDioProvider?> {
  GlobalMessageNotifier() : super(null);

  void showSuccess(String message) {
    state = GlobalInterceptorDioProvider(message, isError: false);
  }

  void showError(String message) {
    state = GlobalInterceptorDioProvider(message, isError: true);
  }

  void clear() {
    state = null;
  }
}
