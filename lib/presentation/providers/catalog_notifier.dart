import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef FetchListCallback<T> = Future<List<T>> Function(
  Map<String, dynamic>? filters,
);

typedef FetchObjectCallback<T> = Future<T> Function(
  Map<String, dynamic>? filters,
);

typedef CacheGetter<T> = List<T> Function();
typedef CacheSaver<T> = Future<void> Function(List<T>);
typedef CacheChecker = bool Function();

/// CatalogNotifier con soporte para caché offline usando Hive
/// Caché primero: si hay datos en Hive se muestran de inmediato y se
/// refrescan desde la API en segundo plano. Solo se espera a la red cuando
/// no hay caché (p. ej. primera instalación).
class CatalogNotifierWithCache<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  final CacheGetter<T> cacheGetter;
  final CacheSaver<T> cacheSaver;
  final CacheChecker cacheChecker;

  // Refresco en curso; se reutiliza para no duplicar peticiones
  Future<void>? _inflight;

  CatalogNotifierWithCache({
    required this.fetch,
    required this.cacheGetter,
    required this.cacheSaver,
    required this.cacheChecker,
  }) : super(const []);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (!mounted) return;

    if (state.isEmpty) {
      try {
        if (cacheChecker()) state = cacheGetter();
      } catch (_) {
        // Caché corrupta: se ignora y se intenta la red
      }
    }

    final refresh = _inflight ??= _refresh(filters);

    // Con datos ya disponibles no se bloquea al llamador
    if (state.isNotEmpty) return;

    await refresh;
  }

  Future<void> _refresh(Map<String, dynamic>? filters) async {
    try {
      final data = await fetch(filters);

      if (!mounted) return;

      // Guardar en caché para uso offline
      await cacheSaver(data);
      if (mounted) state = data;
    } catch (_) {
      // Sin red o timeout: se conserva lo que ya se muestra (caché)
    } finally {
      _inflight = null;
    }
  }
}

/// CatalogNotifier sin caché (compatibilidad con código existente)
class CatalogNotifier<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  bool _isLoading = false;

  CatalogNotifier(this.fetch) : super(const []);

  Future<void> load({Map<String, dynamic>? filters, bool append = false}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      final data = await fetch(filters);

      if (!mounted) return;

      if (append) {
        state = [...state, ...data];
      } else {
        state = data;
      }
    } finally {
      _isLoading = false;
    }
  }
}

/// ObjectCatalogNotifier para objetos individuales
class ObjectCatalogNotifier<T> extends StateNotifier<T?> {
  final FetchObjectCallback<T> fetch;
  bool _isLoading = false;

  ObjectCatalogNotifier(this.fetch) : super(null);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      final data = await fetch(filters);

      if (!mounted) return;

      state = data;
    } catch (e) {
      if (mounted) {
        state = null;
      }
    } finally {
      _isLoading = false;
    }
  }
}
