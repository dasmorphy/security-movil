import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EntryDetails extends StatelessWidget {
  final AllLogbook item;

  const EntryDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Text(
          'Ingreso',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        detailRow('Coordenadas', '${item.lat}, ${item.long}'),
        detailRow('Guía', item.shippingGuide),
        detailRow('Usuario', item.nameUser),
        detailRow('Sector', item.nameSector),
        detailRow('Finca', item.groupName),
        detailRow('Categoría', item.nameCategory),
        detailRow('Cantidad', item.quantity),
        detailRow('Peso', item.weight),
        detailRow('Destino', item.destiny),
        detailRow('Conductor', item.nameDriver),
        detailRow('Placa', item.truckLicense),
        detailRow('Autorización', item.authorizedBy),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations),
      ],
    );
  }
}
