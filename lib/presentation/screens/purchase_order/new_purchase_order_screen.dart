import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      backgroundColor: context.colors.card,
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
