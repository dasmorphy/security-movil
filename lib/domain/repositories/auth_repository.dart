import 'package:zentinel/domain/entities/user_session.dart';

abstract class AuthRepository {
  Future<User> signin(Map<String, dynamic> data);
  Future<void> logout(String token);
}