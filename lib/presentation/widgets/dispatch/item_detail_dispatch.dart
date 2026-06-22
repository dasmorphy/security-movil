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
        detailRow('Tipo', item.typeProcess == 'dispatch' ? 'Materia prima' : 'Producto terminado'),
        detailRow('Placa', item.truckLicense),
        detailRow('Usuario', item.createdBy),
        detailRow('Tipo vehículo', item.nameVehicleType),
        detailRow('Conductor', item.driver),
        detailRow('Destino', item.nameDestiny),
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
