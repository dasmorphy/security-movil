import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/service/pending_request_service.dart';

final syncPendingProvider = StateNotifierProvider<SyncPendingNotifier, bool>((
  ref,
) {
  return SyncPendingNotifier(ref);
});

final connectivityProvider = StreamProvider<bool>((ref) {
  // connectivity_plus 7.x emite List<ConnectivityResult>. Hay conexión si la
  // lista contiene algún resultado distinto de `none`. (Antes se comparaba la
  // List contra el enum, lo que daba SIEMPRE true incluso sin conexión.)
  return Connectivity().onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none))
      // Evita disparar la sincronización en cada micro-evento de red
      // (connectivity_plus emite varios eventos por transición).
      .distinct();
});

final pendingRequestsProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
  final box = Hive.box('pending_requests');

  // emite estado inicial
  yield box.values
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  // escucha cambios
  await for (final _ in box.watch()) {
    yield box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
});

final pendingBiomarProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
  final box = Hive.box('pending_biomar');

  // emite estado inicial
  yield box.values
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  // escucha cambios
  await for (final _ in box.watch()) {
    yield box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
});

final pendingEmployeeMovementsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) async* {
      final box = Hive.box('pending_employee_movements');
      // emite estado inicial
      yield box.values
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // escucha cambios
      await for (final _ in box.watch()) {
        yield box.values
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    });

final pendingRegisterTechProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
  final box = Hive.box('register_technical');
  // emite estado inicial
  yield box.values
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  // escucha cambios
  await for (final _ in box.watch()) {
    yield box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
});

final pendingUpdateTechProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
  final box = Hive.box('update_technical');
  // emite estado inicial
  yield box.values
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  // escucha cambios
  await for (final _ in box.watch()) {
    yield box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
});

/// Firma del envío real de un registro al backend.
/// Recibe el `endpoint` guardado (puede ser null) y el payload ya restaurado,
/// y devuelve `true` si el backend confirmó la recepción.
typedef _Sender =
    Future<bool> Function(String? endpoint, Map<String, dynamic> data);

class SyncPendingNotifier extends StateNotifier<bool> {
  final Ref ref;

  /// Lock global de sincronización. Garantiza que NUNCA corran dos
  /// sincronizaciones a la vez (ni del mismo box ni de boxes distintos),
  /// lo que evitaba los dobles envíos y la "resurrección" de registros.
  bool _running = false;

  /// Tiempo máximo que un registro puede permanecer en `processing` antes de
  /// considerarse colgado por un crash. Solo esos se resetean al iniciar.
  static const Duration _staleProcessing = Duration(minutes: 2);

  SyncPendingNotifier(this.ref) : super(false);

  Future<bool> providerEntry(Map<String, dynamic> data) async {
    return await ref
        .read(saveDepatureReportProvider.notifier)
        .saveLogbookEntry(data);
  }

  Future<bool> providerOut(Map<String, dynamic> data) async {
    return await ref.read(saveOutLogbookProvider.notifier).saveLogbookOut(data);
  }

  Future<ApiResponse> providerEntryBiomar(Map<String, dynamic> data) async {
    return await ref.read(dispatchProvider.notifier).saveEntry(data);
  }

  Future<ApiResponse> providerDispatch(Map<String, dynamic> data) async {
    return await ref.read(dispatchProvider.notifier).saveDispatch(data);
  }

  Future<ApiResponse> providerEmployeeMovements(
    Map<String, dynamic> data,
  ) async {
    return await ref
        .read(saveEmployeeInternProvider.notifier)
        .saveEmployeeMovement(data);
  }

  Future<ApiResponse> providerRegisterTechnical(
    Map<String, dynamic> data,
  ) async {
    return await ref
        .read(technicalRecordProvider.notifier)
        .saveTechnicalRecord(data);
  }

  Future<ApiResponse> providerUpdateTechnical(Map<String, dynamic> data) async {
    return await ref
        .read(technicalRecordProvider.notifier)
        .patchTechnicalRecord(data);
  }

  /// Adquiere el lock de forma SÍNCRONA (antes de cualquier `await`) y ejecuta
  /// `action`. Es la pieza clave: poner `_running = true` antes del primer
  /// `await` cierra la ventana de carrera (TOCTOU) que dejaba pasar varias
  /// ejecuciones simultáneas. El `finally` garantiza la liberación.
  Future<void> _withLock(Future<void> Function() action) async {
    if (_running) {
      print('⏳ Sincronización ya en progreso...');
      return;
    }
    _running = true;
    state = true;
    try {
      if (!await hasInternet()) {
        print(
          '❌ Sin conexión a internet. La sincronización será reintentada cuando haya conexión.',
        );
        return;
      }
      await action();
    } finally {
      _running = false;
      state = false;
    }
  }

  /// Sincroniza TODOS los boxes en serie bajo un único lock. Es el punto de
  /// entrada recomendado para la sincronización automática (conectividad /
  /// resume de la app).
  Future<void> syncAll() async {
    await _withLock(() async {
      await _drainBox(
        boxName: 'pending_requests',
        label: 'logbook',
        send: _sendLogbook,
      );
      await _drainBox(
        boxName: 'pending_biomar',
        label: 'biomar',
        send: _sendBiomar,
      );
      await _drainBox(
        boxName: 'pending_employee_movements',
        label: 'employee',
        send: _sendEmployee,
      );
      await _drainBox(
        boxName: 'register_technical',
        label: 'register_technical',
        send: _sendRegisterTechnical,
      );
      await _drainBox(
        boxName: 'update_technical',
        label: 'update_technical',
        send: _sendUpdateTechnical,
      );
    });
  }

  /// Sincronización manual de un solo box (botón de reintento por pantalla).
  Future<void> sync() => _withLock(
    () => _drainBox(
      boxName: 'pending_requests',
      label: 'logbook',
      send: _sendLogbook,
    ),
  );

  Future<void> syncBiomar() => _withLock(
    () => _drainBox(
      boxName: 'pending_biomar',
      label: 'biomar',
      send: _sendBiomar,
    ),
  );

  Future<void> syncEmployeeMovements() => _withLock(
    () => _drainBox(
      boxName: 'pending_employee_movements',
      label: 'employee',
      send: _sendEmployee,
    ),
  );

  Future<void> syncRegisterTech() => _withLock(
    () => _drainBox(
      boxName: 'register_technical',
      label: 'register_technical',
      send: _sendRegisterTechnical,
    ),
  );

  /// Sincroniza registros nuevos y actualizaciones técnicas bajo el mismo lock.
  Future<void> syncTechnical() => _withLock(() async {
    await _drainBox(
      boxName: 'register_technical',
      label: 'register_technical',
      send: _sendRegisterTechnical,
    );
    await _drainBox(
      boxName: 'update_technical',
      label: 'update_technical',
      send: _sendUpdateTechnical,
    );
  });

  Future<void> syncUpdateTech() => _withLock(
    () => _drainBox(
      boxName: 'update_technical',
      label: 'update_technical',
      send: _sendUpdateTechnical,
    ),
  );

  // --- Senders por tipo de box ---------------------------------------------

  Future<bool> _sendLogbook(String? endpoint, Map<String, dynamic> data) async {
    if (endpoint == 'logbook_out') return providerOut(data);
    if (endpoint == 'logbook_entry') return providerEntry(data);
    return false;
  }

  Future<bool> _sendBiomar(String? endpoint, Map<String, dynamic> data) async {
    if (endpoint == 'entry') return (await providerEntryBiomar(data)).success;
    if (endpoint == 'dispatch') return (await providerDispatch(data)).success;
    return false;
  }

  Future<bool> _sendEmployee(
    String? endpoint,
    Map<String, dynamic> data,
  ) async {
    return (await providerEmployeeMovements(data)).success;
  }

  Future<bool> _sendRegisterTechnical(
    String? endpoint,
    Map<String, dynamic> data,
  ) async {
    return (await providerRegisterTechnical(data)).success;
  }

  Future<bool> _sendUpdateTechnical(
    String? endpoint,
    Map<String, dynamic> data,
  ) async {
    return (await providerUpdateTechnical(data)).success;
  }

  // --- Worker genérico -------------------------------------------------------

  /// Procesa un box completo. NO toma el lock (lo hace `_withLock`), por lo que
  /// asume que es la única ejecución activa sobre Hive.
  Future<void> _drainBox({
    required String boxName,
    required String label,
    required _Sender send,
  }) async {
    final box = Hive.box(boxName);

    // Recuperación de crash: SOLO resetea registros que quedaron colgados en
    // `processing` hace más de `_staleProcessing`. Antes se reseteaban todos
    // de forma incondicional, lo que borraba el flag de un registro en pleno
    // vuelo de otra ejecución y habilitaba el doble envío.
    final now = DateTime.now();
    for (final key in box.keys) {
      final data = box.get(key);
      if (data is Map && data['processing'] == true) {
        final started = DateTime.tryParse(
          data['processingStartedAt']?.toString() ?? '',
        );
        final isStale =
            started == null || now.difference(started) >= _staleProcessing;
        if (isStale) {
          final reset = Map<String, dynamic>.from(data);
          reset['processing'] = false;
          reset.remove('processingStartedAt');
          await box.put(key, reset);
          print('♻️ [$label] Reset processing colgado en request $key');
        }
      }
    }

    final totalPending = box.length;
    if (totalPending == 0) {
      print('✅ [$label] No hay requests pendientes para sincronizar');
      return;
    }

    print(
      '🔄 [$label] Iniciando sincronización de $totalPending request(s) pendiente(s)...',
    );

    int synced = 0;
    int failed = 0;

    // Copia de las keys para evitar problemas al eliminar durante la iteración.
    final keysList = List.from(box.keys);

    for (final key in keysList) {
      final data = box.get(key);
      if (data == null) continue;

      if (data is Map && data['processing'] == true) {
        print('⚠️ [$label] Request $key ya está en procesamiento, se omite.');
        continue;
      }

      try {
        // Marca processing ANTES de enviar.
        final mark = Map<String, dynamic>.from(data as Map);
        mark['processing'] = true;
        mark['processingStartedAt'] = now.toIso8601String();
        await box.put(key, mark);

        final restoredData = restoreFiles(
          Map<String, dynamic>.from(mark['payload']),
        );

        print('📤 [$label] Enviando request $key');

        final response = await send(mark['endpoint'] as String?, restoredData);

        print('📥 [$label] Respuesta api para request $key: $response');

        if (response) {
          await box.delete(key);
          synced++;
          print('✅ [$label] Request $key eliminado de Hive tras sincronizar.');
        } else {
          final unmark = Map<String, dynamic>.from(mark);
          unmark['processing'] = false;
          unmark.remove('processingStartedAt');
          await box.put(key, unmark);
          failed++;
          print('❌ [$label] Request $key falló y se mantendrá para reintento.');
        }
      } catch (e) {
        failed++;
        print('❌ [$label] Error sincronizando request $key: $e');
        // Re-lee el estado ACTUAL: si el registro ya fue borrado por un envío
        // exitoso, no lo "resucitamos" reescribiéndolo.
        final current = box.get(key);
        if (current is Map && current['processing'] == true) {
          final unmark = Map<String, dynamic>.from(current);
          unmark['processing'] = false;
          unmark.remove('processingStartedAt');
          await box.put(key, unmark);
        }
      }
    }

    print(
      '🎉 [$label] Sincronización completada: $synced enviados, $failed fallidos',
    );
  }
}
