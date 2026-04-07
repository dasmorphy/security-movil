import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemDetailEntry extends StatelessWidget {
  final EntryAccessControl item;

  const ItemDetailEntry({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        detailRow('Visitante', item.namesVisit),
        detailRow('Cédula', item.dni),
        detailRow('Área', item.areaName),
        detailRow('Motivo de Visita', item.reasonVisit),
        detailRow('Personal a Cargo', item.staffChargeName),
        detailRow('Creado por', item.createdBy),
        detailRow('Observaciones', item.observationsEntry),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Estado', item.status),
      ],
    );
  }
}
