import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemDetailDispatch extends StatelessWidget {
  final AllDispatch item;

  const ItemDetailDispatch({super.key, required this.item});

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

        detailRow('Código Sku', item.codeSku),
        detailRow('Tipo Sku', item.typeSku),
        detailRow('Placa', item.truckLicense),
        detailRow('Usuario', item.createdBy),
        detailRow('Tipo vehículo', item.nameVehicleType),
        detailRow('Conductor', item.driver),
        detailRow('Peso', item.weight),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations),
      ],
    );
  }
}
