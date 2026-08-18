import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/technical/technical_record_tile.dart';

class ItemRecentTechnicalRecord extends ConsumerWidget {
  const ItemRecentTechnicalRecord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(getTechnicalRecord);
    final recentRecords = records.take(5).toList();

    if (recentRecords.isEmpty) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: [
        for (final record in recentRecords)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TechnicalRecordTile(item: record),
          ),
      ],
    );
  }
}
