import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/dio/dio_provider.dart';
import 'package:zentinel/infraestructure/datasources/round_impl.dart';
import 'package:zentinel/infraestructure/repositories/round_repository_impl.dart';

//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final roundRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return RoundRepositoryImpl(RoundImpl(dio: dio));
});