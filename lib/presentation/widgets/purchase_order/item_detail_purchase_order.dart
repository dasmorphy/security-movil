import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/purchase_order.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemDetailPurchaseOrder extends ConsumerWidget {
  final PurchaseOrder item;

  const ItemDetailPurchaseOrder({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userSessionProvider);
    final userData = authState.value!;
    
    return Column(
      children: [
        const SizedBox(height: 20),
        detailRow('Orden', item.numberOrder),
        detailRow('Inicio', formatDateDetails(item.startDate.toString())),
        detailRow('Fin', formatDateDetails(item.endDate.toString())),

        if (userData.role != 'guardia')...[
          detailRow('Cantidad', item.quantity),
          // detailRow('Destino', item.destinyName),
          detailRow(
            'Fecha Ingreso',
            formatDateDetails(item.createdAt.toString()),
          ),
          detailRow('Observaciones', item.observations),
          detailRow('Estado', item.statusName),
        ],
      ],
    );
  }
}
