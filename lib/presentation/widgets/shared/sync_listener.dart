import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/sync_pending/sync_pending_provider.dart';

/// Widget que escucha cambios de conectividad y sincroniza automáticamente
/// Debe estar envuelto en un ProviderScope para funcionar correctamente
class SyncListener extends ConsumerWidget {
  final Widget child;

  const SyncListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar cambios de conectividad
    ref.listen(connectivityProvider, (previous, next) {
      // next es un AsyncValue<bool>
      next.whenData((hasInternet) {
        if (hasInternet) {
          print('📡 Internet detectado: iniciando sincronización...');
          ref.read(syncPendingProvider.notifier).sync();
        }
      });
    });

    return child;
  }
}
