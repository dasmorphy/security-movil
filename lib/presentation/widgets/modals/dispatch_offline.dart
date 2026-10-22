import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class DispatchOffline extends ConsumerWidget {
  const DispatchOffline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBiomarProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOffline(
          headerTxt: 'Registros offline', 
          pendingAsync: pendingAsync, 
          sync: ref.read(syncPendingProvider.notifier).syncBiomar,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.card,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
              child: pendingAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: TextStyle(color: context.colors.textPrimary.withOpacity(0.7)),
                  ),
                ),
                data: (pending) {
                  final items = pending.map(mapPendingBiomar).toList();

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Sin registros pendientes',
                        style: TextStyle(color: context.colors.textPrimary.withOpacity(0.7)),
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
                      color: context.colors.overlayPanel,
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
                                color: (context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.upload_file,
                                color: context.colors.textPrimary.withOpacity(0.54),
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: context.colors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 6),
                                  
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          color: context.colors.textPrimary.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                  
                                      const SizedBox(height: 6),
                                  
                                      Text(
                                        statusText,
                                        style: TextStyle(
                                          color: context.colors.textPrimary.withOpacity(0.7),
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
                                    )
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
}
