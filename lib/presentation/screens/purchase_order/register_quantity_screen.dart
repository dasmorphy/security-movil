import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/purchase_order.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class RegisterQuantityScreen extends ConsumerWidget {
  static const name = 'register-quantity-screen';

  final PurchaseOrder purchaseOrder;

  const RegisterQuantityScreen({super.key, required this.purchaseOrder});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final purchseOrderHeader = HeaderInfoPurchaseOrder(
      purchaseOrderId: purchaseOrder.idOrder,
      numberOrder: purchaseOrder.numberOrder,
      typeOrder: purchaseOrder.typeOrder,
      destinyName: purchaseOrder.destinyName
    );

    return RegisterQuantityForm(
      puchaseOrder: purchseOrderHeader,
      onSubmit: (data) async {
        print('Datos de recepción: $data');
        return await ref
          .read(postApiResponseProvider.notifier)
          .savePurchaseOrderReceipts(data);
      }
    );
  }
}
