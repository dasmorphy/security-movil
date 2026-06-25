import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/purchase_order.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemDetailPurchaseOrder extends StatelessWidget {
  final PurchaseOrder item;

  const ItemDetailPurchaseOrder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        detailRow('Orden', item.numberOrder),
        detailRow('Cantidad', item.quantity),
        detailRow('Destino', item.destinyName),
        detailRow(
          'Fecha Ingreso',
          formatDateDetails(item.createdAt.toString()),
        ),
        detailRow('Observaciones', item.observations),
        detailRow('Estado', item.statusName),
      ],
    );
  }
}
