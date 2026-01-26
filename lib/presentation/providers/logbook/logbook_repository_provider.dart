import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/infraestructure/datasources/logbook_entry_impl.dart';
import 'package:zentinel/infraestructure/repositories/logbook_entry_repository_impl.dart';

//Este repositorio es inmutable ya que se esta usando Provider
//Su objetivo es proporcionar a todos los demas providers la informacion necesaria para consultar el datasourceimpl
final logbookEntryRepositoryProvider = Provider((ref) {
  return LogbookEntryRepositoryImpl(LogbookEntryImpl());
});