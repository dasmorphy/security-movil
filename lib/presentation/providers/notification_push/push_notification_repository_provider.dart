import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/dio/dio_push_notification.dart';
import 'package:zentinel/infraestructure/datasources/push_notification_impl.dart';
import 'package:zentinel/infraestructure/repositories/push_notification_repository_impl.dart';

//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final pushNotificationRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioPushNotificationProvider);
  return PushNotificationRepositoryImpl(PushNotificationImpl(dio: dio));
});