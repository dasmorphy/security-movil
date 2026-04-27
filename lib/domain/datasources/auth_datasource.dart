
import 'package:zentinel/domain/entities/user_session.dart';

abstract class AuthDatasource {
  Future<User> signin(Map<String, dynamic> data);
  Future<dynamic> logout(String token);
}