import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/service/pending_request_service.dart';

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
/// Intenta obtener datos de internet primero, si falla usa caché
class CatalogNotifierWithCache<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  final CacheGetter<T> cacheGetter;
  final CacheSaver<T> cacheSaver;
  final CacheChecker cacheChecker;
  bool _isLoading = false;

  CatalogNotifierWithCache({
    required this.fetch,
    required this.cacheGetter,
    required this.cacheSaver,
    required this.cacheChecker,
  }) : super(const []);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      // Verificar si hay conexión a internet
      final hasConnection = await hasInternet();

      if (hasConnection) {
        // Intentar obtener datos de internet
        try {
          final data = await fetch(filters);

          if (!mounted) return;

          // Guardar en caché para uso offline
          await cacheSaver(data);
          state = data;
        } catch (e) {
          // Si falla internet, usar caché
          if (!mounted) return;

          if (cacheChecker()) {
            state = cacheGetter();
          } else {
            state = [];
          }
        }
      } else {
        // Sin conexión, usar caché
        if (!mounted) return;

        if (cacheChecker()) {
          state = cacheGetter();
        } else {
          state = [];
        }
      }
    } catch (e) {
      if (mounted) {
        state = [];
      }
    } finally {
      _isLoading = false;
    }
  }
}

/// CatalogNotifier sin caché (compatibilidad con código existente)
class CatalogNotifier<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  bool _isLoading = false;

  CatalogNotifier(this.fetch) : super(const []);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      final data = await fetch(filters);

      if (!mounted) return;

      state = data;
    } catch (e) {
      if (mounted) {
        state = [];
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
