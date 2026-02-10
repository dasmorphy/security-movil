import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_provider.dart';
import 'package:zentinel/service/pending_request_service.dart';


final syncPendingProvider =
    StateNotifierProvider<SyncPendingNotifier, bool>((ref) {
  return SyncPendingNotifier(ref);
});

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
});



class SyncPendingNotifier extends StateNotifier<bool> {
  final Ref ref;
  bool _running = false;

  SyncPendingNotifier(this.ref) : super(false);

  Future<bool> providerEntry(Map<String, dynamic> data) async {
    return await ref.read(saveDepatureReportProvider.notifier).saveLogbookEntry(data);
  }

  Future<bool> providerOut(Map<String, dynamic> data) async {
    return await ref.read(saveOutLogbookProvider.notifier).saveLogbookOut(data);
  }

  Future<void> sync() async {
    // Verifica si ya hay una sincronización en curso
    if (_running) {
      print('⏳ Sincronización ya en progreso...');
      return;
    }
    
    // Valida que haya internet disponible
    if (!await hasInternet()) {
      print('❌ Sin conexión a internet. La sincronización será reintentada cuando haya conexión.');
      return;
    }

    _running = true;
    state = true;

    final box = Hive.box('pending_requests');
    final totalPending = box.length;

    if (totalPending == 0) {
      print('✅ No hay requests pendientes para sincronizar');
      state = false;
      _running = false;
      return;
    }

    print('🔄 Iniciando sincronización de $totalPending request(s) pendiente(s)...');

    int synced = 0;
    int failed = 0;

    // Itera sobre una copia de las keys para evitar problemas de iteración durante la eliminación
    final keysList = List.from(box.keys);
    
    for (final key in keysList) {
      final data = box.get(key);
      if (data == null) continue;

      // Si ya está marcado como processing, saltar para evitar dobles envíos
      if (data is Map && data['processing'] == true) {
        print('⚠️ Request $key ya está en procesamiento, se omite.');
        continue;
      }

      try {
        // Marcar como processing antes de enviar para evitar race conditions
        final Map<String, dynamic> mark = Map<String, dynamic>.from(data as Map);
        mark['processing'] = true;
        await box.put(key, mark);

        // Restaurar archivos (paths -> File)
        final restoredData = restoreFiles(
          Map<String, dynamic>.from(mark['payload']),
        );

        print('📤 Enviando request $key con payload: $restoredData');

        bool response = false;

        if (mark['endpoint'] == 'logbook_out') {
          response = await providerOut(restoredData);
        } else if (mark['endpoint'] == 'logbook_entry') {
          response = await providerEntry(restoredData);
        }

        print('Respuesta api para request $key: $response');

        if (response) {
          // Eliminamos en caso de éxito
          await box.delete(key);
          synced++;
          print('✅ Request $key eliminado de Hive tras sincronizar.');
        } else {
          // Desmarcar processing para reintentar luego
          final Map<String, dynamic> unmark = Map<String, dynamic>.from(mark);
          unmark['processing'] = false;
          await box.put(key, unmark);
          failed++;
          print('❌ Request $key falló y se mantendrá para reintento.');
        }

      } catch (e) {
        failed++;
        print('❌ Error sincronizando request $key: $e');
        try {
          // Intentar desmarcar processing en caso de excepción
          if (data is Map) {
            final Map<String, dynamic> unmark = Map<String, dynamic>.from(data);
            unmark['processing'] = false;
            await box.put(key, unmark);
          }
        } catch (_) {
          // no hacemos nada si falla el desmarcado
        }
        // Continúa con el siguiente en lugar de romper el ciclo
      }
    }

    print('🎉 Sincronización completada: $synced enviados, $failed fallidos');
    
    state = false;
    _running = false;
  }
}
