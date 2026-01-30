import 'package:flutter_riverpod/flutter_riverpod.dart';


final authProvider =
    StateNotifierProvider<AuthNotifier, Map<String, dynamic>>(
  (ref) => AuthNotifier(),
);


class AuthNotifier
    extends StateNotifier<Map<String, dynamic>> {

  AuthNotifier() : super({});

  void authUser(Map<String, dynamic> dataUser) {
    state = dataUser;
  }
}
