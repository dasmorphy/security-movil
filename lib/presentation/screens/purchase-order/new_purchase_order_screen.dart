import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NewPurchaseOrderScreen extends ConsumerStatefulWidget {
  static const name = 'new-purchase-order-screen';

  const NewPurchaseOrderScreen({super.key});

  @override
  ConsumerState<NewPurchaseOrderScreen> createState() =>
      _NewPurchaseOrderScreenState();
}

class _NewPurchaseOrderScreenState
    extends ConsumerState<NewPurchaseOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: 'Nueva orden de compra'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        child: PurchaseOrderForm(
          onSubmit: (data) async {
            return await ref
              .read(postApiResponseProvider.notifier)
              .savePurchaseOrder(data);
          },
        ),
      ),
    );
  }
}
