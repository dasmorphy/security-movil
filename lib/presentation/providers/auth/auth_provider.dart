import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/domain/repositories/auth_repository.dart';
import 'package:zentinel/presentation/providers/auth/auth_repository_provider.dart';

/// Provider
final userSessionProvider =
    StateNotifierProvider<UserSessionNotifier, AsyncValue<User?>>((ref) {
      final authRepository = ref.read(authRepositoryProvider);
      return UserSessionNotifier(authRepository);
    });

/// Notifier
class UserSessionNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository authRepository;

  UserSessionNotifier(this.authRepository) : super(const AsyncValue.data(null));

  Future<void> signin(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();

    try {
      final user = await authRepository.signin(data);
      print('user');
      state = AsyncValue.data(user);
    } on DioException catch (e) {
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

  void logout() {
    state = const AsyncValue.data(null);
  }
}
