import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/presentation/widgets/modals/technical_record_detail_modal.dart';
import 'package:zentinel/presentation/widgets/shared/open_modal.dart';

class TechnicalRecordTile extends StatelessWidget {
  final TechnicalRecord item;

  const TechnicalRecordTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => ModalHelper.open(
        context,
        child: TechnicalRecordDetailModal(item: item),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.taskCode,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.clientName} - ${item.locationName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 180, 180, 180),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Creado por ${item.createdBy}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 180, 180, 180),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatDate(item.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 180, 180, 180),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              side: BorderSide.none,
              label: Text(item.status),
              backgroundColor: getStatusBackgroundTechRecord(item.status),
              padding: EdgeInsets.zero,
              labelStyle: TextStyle(
                color: getStatusColorTechRecord(item.status),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
