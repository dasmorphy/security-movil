import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/presentation/providers/catalog_notifier.dart';
import 'package:zentinel/presentation/providers/technical/technical_repository_provider.dart';

final getTaskTechnical =
    StateNotifierProvider<CatalogNotifier<TaskTechnical>, List<TaskTechnical>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<TaskTechnical>(
    (_) => repo.getTaskTechnical(),
  );
});