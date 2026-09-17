import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListPurchaseOrderScreen extends ConsumerStatefulWidget  {

  static const name = 'list-purchase-order-screen';

  const ListPurchaseOrderScreen({super.key});

  @override
  ConsumerState<ListPurchaseOrderScreen> createState() => _ListPurchaseOrderScreenState();
}

class _ListPurchaseOrderScreenState extends ConsumerState<ListPurchaseOrderScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getPurchaseOrder.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyPurchaseOrder = ref.watch(getPurchaseOrder);
    final filtered = historyPurchaseOrder.where((item) {
      final text = searchText.toLowerCase();

      final numberOrder = (item.numberOrder).toLowerCase();
      final provider = (item.provider).toLowerCase();

      return numberOrder.contains(text) || provider.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Órdenes de compra',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
              const SizedBox(height: 30,),
              Expanded(child: ListPurchaseOrder(items: filtered)),
            ],
          )
        ),
      ),
    );
  }
}