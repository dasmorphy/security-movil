import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NewProductScreen extends ConsumerWidget {
  static const name = 'new-product-screen';

  const NewProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: 'Registro de producto'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        child: ProductForm(
          onSubmit: (data) async {
            return await ref
              .read(technicalRecordProvider.notifier)
              .saveProduct(data);
          },
        ),
      ),
    );
  }
}
