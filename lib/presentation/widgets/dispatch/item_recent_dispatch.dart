import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemRecentDispatch extends ConsumerWidget {
  const ItemRecentDispatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyDispatch = ref.watch(getHistoryDispatch);
    final limitedList = historyDispatch.take(5).toList();

    if (historyDispatch.isEmpty) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: List.generate(limitedList.length, (index) {
          final item = limitedList[index];
      
          final typeText = item.orderNumber;
          final createdBy = item.createdBy;
          final description = 'Orden $typeText - Placa ${item.truckLicense}';
      
          final formattedDate = formatDate(item.createdAt);
      
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => ModalHelper.open(
                context,
                child: DispatchDetailModal(item: item),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                        ],
                      ),
                    ),
                      
                    Chip(
                      side: BorderSide.none,
                      label: Text(item.status),
                      backgroundColor: getStatusColorBckgDispatch(item.status),
                      padding: EdgeInsets.zero,
                      labelStyle: TextStyle(
                        color: getStatusColorDispatch(item.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
