import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/user_session.dart' show UserSession;
import 'package:zentinel/presentation/providers/auth/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void setSession(UserSession session) {
    state = AuthState(session: session);
  }

  void clearSession() {
    state = const AuthState();
  }

  UserSession? get session => state.session;
}
