import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/blacklist_driver.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemDetailBlacklist extends StatelessWidget {
  final BlacklistDriver item;

  const ItemDetailBlacklist({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        detailRow('Identificación', item.dni),
        detailRow('Nombres completos', item.fullNames),
        detailRow('Restricción', item.reasonRestriction),
        detailRow('Usuario', item.createdBy),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations),
      ],
    );
  }
}
