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
        detailRow('N. Orden', item.orderNumber),
        detailRow('Placa', item.truckLicense),
        detailRow('Usuario', item.createdBy),
        detailRow('Tipo vehículo', item.nameVehicleType),
        detailRow('Conductor', item.driver),
        detailRow('Peso', item.weight),
        detailRow('Estado', item.status),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations),
      ],
    );
  }
}
