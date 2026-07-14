import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/dio/dio_provider.dart';
import 'package:zentinel/infraestructure/datasources/technical_impl.dart';
import 'package:zentinel/infraestructure/repositories/technical_repository_impl.dart';

//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final technicalRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return TechnicalRepositoryImpl(TechnicalImpl(dio: dio));
});