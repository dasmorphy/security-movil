import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemRecentRound extends ConsumerWidget {
  const ItemRecentRound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyRounds = [];
    final limitedList = historyRounds.take(5).toList();

    if (historyRounds.isEmpty) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: List.generate(limitedList.length, (index) {
        final item = limitedList[index];

        final isEntry = item.idLogbookEntry;
        final typeText = isEntry != null ? 'ingreso' : 'salida';

        final createdBy = item.nameUser;
        final groupName = item.groupName;

        final description = 'Bitácora de $typeText en $groupName';

        final formattedDate = formatDate(item.createdAt);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => ModalHelper.open(
              context,
              child: BitacoraDetailModal(item: item),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 4, 88, 99),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.edit_note_sharp,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        createdBy,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),

                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color.fromARGB(255, 180, 180, 180),
                        ),
                      ),
                      const SizedBox(height: 2),

                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color.fromARGB(255, 180, 180, 180),
                        ),
                      ),
                      const SizedBox(height: 2),

                      Chip(
                        label: Text(item.status),
                        backgroundColor: item.status == 'Finalizado'
                            ? const Color.fromARGB(255, 34, 197, 94)
                            : const Color.fromARGB(255, 224, 157, 49),
                        padding: EdgeInsets.zero,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
