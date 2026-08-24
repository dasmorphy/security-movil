import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class RegisterTecninalOffline extends ConsumerWidget {
  const RegisterTecninalOffline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingRegisterTechProvider);
    final updateAsync = ref.watch(pendingUpdateTechProvider);

    final AsyncValue<List<Map<String, dynamic>>> combinedPendingAsync;

    if (pendingAsync.isLoading || updateAsync.isLoading) {
      combinedPendingAsync = const AsyncLoading();
    } else if (pendingAsync.hasError) {
      combinedPendingAsync = AsyncError(
        pendingAsync.error!,
        pendingAsync.stackTrace!,
      );
    } else if (updateAsync.hasError) {
      combinedPendingAsync = AsyncError(
        updateAsync.error!,
        updateAsync.stackTrace!,
      );
    } else {
      combinedPendingAsync = AsyncData([
        ...(pendingAsync.value ?? []).map(
          (item) => {...item, '_technicalOperation': 'register'},
        ),
        ...(updateAsync.value ?? []).map(
          (item) => {...item, '_technicalOperation': 'update'},
        ),
      ]);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderOffline(
          headerTxt: 'Registros técnicos offline',
          pendingAsync: combinedPendingAsync,
          sync: ref.read(syncPendingProvider.notifier).syncTechnical,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: combinedPendingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            data: (pending) {
              final items = pending.map(_mapPendingTechnical).toList();

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'Sin registros pendientes',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final it = items[index];
                  final name = it['name'];
                  final statusText = it['statusText'];
                  final subtitle = it['subtitle'];

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                color: Colors.white54,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        statusText,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (statusText != 'Pendiente')
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _mapPendingTechnical(Map<String, dynamic> raw) {
    final isUpdate = raw['_technicalOperation'] == 'update';
    final processing = raw['processing'] == true;

    return {
      'name': isUpdate ? 'Actualización técnica' : 'Registro técnico',
      'subtitle': isUpdate ? 'Actualización' : 'Nuevo registro',
      'statusText': processing ? 'Subiendo...' : 'Pendiente',
    };
  }
}
