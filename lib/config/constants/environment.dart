import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static String baseUrl = dotenv.env['ZENTINEL_BASE_URL'] ?? 'No hay api key';
  static String localDevUrl = dotenv.env['ZENTINEL_LOCAL_DEV_URL'] ?? 'No hay api key';
  static String technicalUrl = dotenv.env['TECHNICAL_BASE_URL'] ?? 'No hay api key';
}