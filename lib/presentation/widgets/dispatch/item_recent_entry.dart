import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemRecentEntry extends ConsumerWidget {
  const ItemRecentEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyEntryAccess = ref.watch(getHistoryEntryAccess);
    final limitedList = historyEntryAccess.take(5).toList();

    if (historyEntryAccess.isEmpty) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: List.generate(limitedList.length, (index) {
        final item = limitedList[index];

        final createdBy = item.createdBy;
        final description = '${item.namesVisit} - ${item.dni}';

        final formattedDate = formatDate(item.createdAt);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => ModalHelper.open(
              context,
              child: EntryAccessDetailModal(item: item),
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
                        backgroundColor: getStatusColorEntryAccess(item.status),
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
