import 'package:flutter/material.dart';
import 'package:zentinel/service/navigation_service.dart';

enum OverlayStatus { loading, success, error, warning }

class GlobalLoadingBottomSheet {
  static OverlayEntry? _overlayEntry;

  static void show({
    OverlayStatus status = OverlayStatus.loading,
    String? message,
    Duration? autoDismiss, // para success/error/warning se cierra solo
  }) {
    hide(); // si hay uno activo, lo reemplaza

    final overlay = NavigationService.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    final defaultMessage = switch (status) {
      OverlayStatus.loading => 'Actualizando estado...',
      OverlayStatus.success => 'Guardado exitosamente',
      OverlayStatus.error   => 'Ocurrió un error',
      OverlayStatus.warning => 'Verifica los datos',
    };

    _overlayEntry = OverlayEntry(
      builder: (_) => _LoadingOverlay(
        status: status,
        message: message ?? defaultMessage,
      ),
    );

    overlay.insert(_overlayEntry!);

    // Auto-dismiss para estados finales
    final dismissAfter = autoDismiss ??
        (status != OverlayStatus.loading ? const Duration(seconds: 2) : null);

    if (dismissAfter != null) {
      Future.delayed(dismissAfter, hide);
    }
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _LoadingOverlay extends StatelessWidget {
  final OverlayStatus status;
  final String message;

  const _LoadingOverlay({required this.status, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return switch (status) {
      OverlayStatus.loading => const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.green,
          ),
        ),
      OverlayStatus.success => _circleIcon(
          color: Colors.green,
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        ),
      OverlayStatus.error => _circleIcon(
          color: Colors.red,
          child: const Icon(Icons.close, size: 14, color: Colors.white),
        ),
      OverlayStatus.warning => _circleIcon(
          color: Colors.orange,
          child: const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
        ),
    };
  }

  Widget _circleIcon({required Color color, required Widget child}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}