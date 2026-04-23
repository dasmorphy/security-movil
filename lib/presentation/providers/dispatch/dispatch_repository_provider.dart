import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/dio/dio_provider.dart';
import 'package:zentinel/infraestructure/datasources/dispatch_impl.dart';
import 'package:zentinel/infraestructure/repositories/dispatch_repository_impl.dart';

//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final dispatchRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return DispatchRepositoryImpl(DispatchImpl(dio: dio));
});