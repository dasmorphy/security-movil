


import 'package:zentinel/domain/datasources/auth_datasource.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:zentinel/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDatasource datasource;
  AuthRepositoryImpl(this.datasource);
  
  @override
  Future<User> signin(Map<String, dynamic> data) {
    return datasource.signin(data);
  }
  
  @override
  Future<void> logout(String token) {
    return datasource.logout(token);
  }

}