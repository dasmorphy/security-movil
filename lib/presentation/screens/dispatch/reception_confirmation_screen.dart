import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ReceptionConfirmationScreen extends ConsumerWidget {
  static const name = 'reception-confirmation-screen';

  final AllDispatch dispatchData;

  const ReceptionConfirmationScreen({super.key, required this.dispatchData});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final dispatchHeader = DispatchData(
      dispatchId: dispatchData.idDispatch,
      orderNumber: dispatchData.orderNumber,
      destiny: dispatchData.nameDestiny,
      driver: dispatchData.driver,
      status: dispatchData.status,
      statusColor: getStatusColorDispatch(dispatchData.status),
    );

    final products = dispatchData.skus
    .expand((sku) => sku.products)
    .map((product) {
      return ReceivedProduct(
        id: product.idProductSku,
        productName: product.name,
        status: 'CORRECTO',
        expectedQty: product.quantity,
        receivedQty: product.quantity,
        commentary: '',
        hasDiscrepancy: false,
      );
    })
    .toList();

    return ReceptionConfirmationForm(
      dispatchData: dispatchHeader,
      products: products,
      onSubmit: (data) async {
        print('Datos de recepción: $data');
        final authState = ref.watch(userSessionProvider);
        final userData = authState.value!;
        data['user'] = userData.user;
        final saveReceptionProvider = ref.read(dispatchProvider.notifier);
        return await saveReceptionProvider.saveReception(data);
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
