import 'package:dio/dio.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/auth_datasource.dart';
import 'package:zentinel/domain/entities/user_session.dart';

class AuthImpl extends AuthDatasource {
  final Dio dio;

  AuthImpl({required this.dio});

  @override
  Future<User> signin(Map<String, dynamic> data) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": "fcea920f7412b5da7be0cf42b8c93759",
      "login": data,
    };

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/login',
      data: dataBody,
      options: onlyError(),
    );

    return User.fromJson(response.data['data']);
  }

}