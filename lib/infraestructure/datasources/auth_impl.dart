import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/datasources/auth_datasource.dart';
import 'package:zentinel/domain/entities/user_session.dart';

class AuthImpl extends AuthDatasource {
  final Dio dio;
  final uuid = Uuid().v4();

  AuthImpl({required this.dio});

  @override
  Future<User> signin(Map<String, dynamic> data) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": uuid,
      "login": data,
    };

    final response = await dio.post(
      '/rest/zent-logbook-api/v1.0/post/login',
      data: dataBody,
      options: onlyError(),
    );

    // Extraer el access_token del response
    final accessToken = response.data['access_token'] as String;
    
    // Decodificar el JWT para extraer los datos del usuario
    final decodedToken = JwtDecoder.decode(accessToken);
    
    // Crear el usuario a partir del token decodificado
    final user = User(
      attributes: decodedToken['attributes'] ?? {},
      email: decodedToken["email"] ?? '',
      idUser: decodedToken["id_user"] ?? decodedToken["sub"] ?? '',
      isActive: decodedToken["is_active"] ?? true,
      user: decodedToken["user"] ?? '',
      role: decodedToken["role"] ?? '',
    );
    
    // Guardar el token en los atributos para recuperarlo después
    user.attributes['accessToken'] = accessToken;
    
    return user;
  }
  
  @override
  Future<void> logout(String token) async {
    final dataBody = {
      "channel": "ZENTINEL",
      "externalTransactionId": uuid,
      "logout": {"token": token},
    };

    await dio.post(
      '/rest/zent-logbook-api/v1.0/post/logout',
      data: dataBody,
      // options: onlyError(),
    );
  }

}