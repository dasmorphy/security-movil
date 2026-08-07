import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/domain/repositories/auth_repository.dart';
import 'package:zentinel/presentation/providers/auth/auth_repository_provider.dart';
import 'package:zentinel/data/services/hive_service.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';

/// Provider para cargar sesión persistida
final persistedSessionProvider = FutureProvider<User?>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  final sessionModel = hiveService.getUserSession();
  
  if (sessionModel != null) {
    return User(
      attributes: {
        ...sessionModel.attributes,
        'accessToken': sessionModel.token,
      },
      email: sessionModel.email,
      idUser: sessionModel.userId,
      isActive: sessionModel.isActive,
      user: sessionModel.user,
      role: sessionModel.role,
    );
  }
  return null;
});

/// Provider
final userSessionProvider =
    StateNotifierProvider<UserSessionNotifier, AsyncValue<User?>>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final hiveService = ref.read(hiveServiceProvider);
  return UserSessionNotifier(authRepository, hiveService, ref);
});


/// Notifier
class UserSessionNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository authRepository;
  final HiveService hiveService;
  final Ref ref;

  UserSessionNotifier(this.authRepository, this.hiveService, this.ref) 
      : super(const AsyncValue.data(null)) {
    // Cargar sesión persistida al inicializar
    _loadPersistedSession();
  }

  void _loadPersistedSession() {
    try {
      final sessionModel = hiveService.getUserSession();
      
      if (sessionModel != null) {
        final user = User(
          attributes: {
            ...sessionModel.attributes,
            'accessToken': sessionModel.token, // Restaurar el token JWT
          },
          email: sessionModel.email,
          idUser: sessionModel.userId,
          isActive: sessionModel.isActive,
          user: sessionModel.user,
          role: sessionModel.role,
        );
        state = AsyncValue.data(user);
      }
    } catch (e) {
      print('Error cargando sesión persistida: $e');
    }
  }

  Future<void> signin(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();

    try {
      final user = await authRepository.signin(data);
      
      // Guardar sesión en Hive
      await hiveService.saveUserSession(user);

      state = AsyncValue.data(user);

      // El interceptor toma el JWT de este provider, por eso va después del state.
      await _registerFcmToken(user);
    } on DioException catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Error de autenticación',
        StackTrace.current,
      );
    } catch (e, st) {
      print(e);
      print(st);
      state = AsyncValue.error('Error inesperado', st);
    }
  }

  /// Envía el token FCM del dispositivo al backend tras iniciar sesión.
  /// Un fallo aquí no debe romper el login.
  Future<void> _registerFcmToken(User user) async {
    final fcmToken = await PushNotificationProvider.instance.resolveFcmToken();

    if (fcmToken == null || fcmToken.isEmpty) {
      print('Sin token FCM disponible, no se registra en el backend');
      return;
    }

    await _sendFcmToken(user, fcmToken);
  }

  /// Reenvía al backend un token rotado por Firebase (onTokenRefresh).
  /// Si no hay sesión activa no se envía: el token ya quedó en
  /// SharedPreferences y se registrará en el próximo login.
  Future<void> syncFcmToken(String fcmToken) async {
    final user = state.value;
    if (user == null) return;

    await _sendFcmToken(user, fcmToken);
  }

  Future<void> _sendFcmToken(User user, String fcmToken) async {
    try {
      final response = await ref
          .read(pushNotificationFetchProvider.notifier)
          .saveFcmTokenUser({
            'fcm_token': fcmToken,
            'platform': PushNotificationProvider.instance.platform,
            'project_id': 1,
            'user_id': user.idUser,
          });

      if (!response.success) {
        print('No se pudo guardar el token FCM: ${response.message}');
      }
    } catch (e) {
      print('Error registrando token FCM: $e');
    }
  }

  Future<void> logout() async {
    final userSession = state.value;

    try {
      if (userSession != null) {
        final token = userSession.attributes['accessToken'] as String?;
        await authRepository.logout(token ?? "");
      }
    } catch (e) {
      print('Error al llamar logout API: $e');
    }

    // Eliminar sesión de Hive
    await hiveService.deleteUserSession();
    state = const AsyncValue.data(null);
  }
}
