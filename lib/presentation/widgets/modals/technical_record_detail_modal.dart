import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/presentation/widgets/logbook/detail_row.dart';

class TechnicalRecordDetailModal extends StatelessWidget {
  final TechnicalRecord item;

  const TechnicalRecordDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final staffNames =
        item.technicalStaff
            ?.map((staff) => staff.name)
            .whereType<String>()
            .where((name) => name.isNotEmpty)
            .join(', ') ??
        '';
    final materials =
        item.materials
            ?.map((material) {
              final name = material.material ?? 'Material';
              final quantity = material.quantity;
              return quantity == null ? name : '$name ($quantity)';
            })
            .join(', ') ??
        '';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detalle del registro técnico',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    detailRow('Código de tarea', item.taskCode),
                    detailRow('Cliente', item.clientName),
                    detailRow('Ubicación', item.locationName),
                    detailRow('Resumen', item.resume),
                    detailRow('Estado', item.status),
                    detailRow('Creado por', item.createdBy),
                    detailRow('Fecha de creación', formatDate(item.createdAt)),
                    if (staffNames.isNotEmpty)
                      detailRow('Personal técnico', staffNames),
                    if (materials.isNotEmpty)
                      detailRow('Materiales', materials),
                    if (item.vehicle != null &&
                        item.vehicle.toString().isNotEmpty)
                      detailRow('Vehículo', item.vehicle.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
