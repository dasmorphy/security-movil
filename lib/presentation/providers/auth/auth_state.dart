import 'package:zentinel/domain/entities/user_session.dart';

class AuthState {
  final UserSession? session;
  final bool isLoading;

  const AuthState({
    this.session,
    this.isLoading = false,
  });

  bool get isLoggedIn => session != null;
}
