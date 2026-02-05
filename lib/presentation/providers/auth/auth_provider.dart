import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/domain/repositories/auth_repository.dart';
import 'package:zentinel/presentation/providers/auth/auth_repository_provider.dart';

/// Provider
final userSessionProvider = StateNotifierProvider<UserSessionNotifier, User?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UserSessionNotifier(authRepository);
});

/// Notifier
class UserSessionNotifier extends StateNotifier<User?> {
  final AuthRepository authRepository;
  bool isLoading = false;

  UserSessionNotifier(this.authRepository) : super(null);

  Future<void> signin(Map<String, dynamic> data) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final user = await authRepository.signin(data);
      print(user);
      state = user;
    } finally {
      isLoading = false;
    }
  }

  void logout() {
    state = null;
  }
}
