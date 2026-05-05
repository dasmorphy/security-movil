import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_round.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class RoundDetail extends StatelessWidget {
  final AllRound item;

  const RoundDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Text(
          'Detalle Ronda',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        detailRow('Coordenadas', '${item.lat}, ${item.long}'),
        detailRow('Usuario', item.createdBy),
        detailRow('Sector', item.nameSector),

        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations == '' ? 'Sin observaciones' : item.observations),
      ],
    );
  }
}
