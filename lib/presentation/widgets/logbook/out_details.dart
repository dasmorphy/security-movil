import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class OutDetails extends StatelessWidget {
  final dynamic out;

  const OutDetails({super.key, required this.out});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Text(
          'Salida',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        detailRow('Coordenadas', '${out.lat}, ${out.long}'),
        detailRow('Guía', out.shippingGuide),
        detailRow('Usuario', out.nameUser),
        detailRow('Sector', out.nameSector),
        detailRow('Finca', out.groupName),
        detailRow('Categoría', out.nameCategory),
        detailRow('Custodia', out.personWithdraws),
        detailRow('Cantidad', out.quantity),
        detailRow('Peso', out.weight),
        detailRow('Destino', out.destiny),
        detailRow('Conductor', out.nameDriver),
        detailRow('Placa', out.truckLicense),
        detailRow('Autorización', out.authorizedBy),
        detailRow('Fecha Salida', formatDateDetails(out.createdAt.toString())),
        detailRow('Observaciones', out.observations),
      ],
    );
  }
}
