import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity, //Le da todo el ancho disponible
          child: Row(
            children: [
              // Image.asset(
              //   'lib/assets/images/zentinel_logo.svg',
              //   width: 24,
              //   height: 24,
              //   fit: BoxFit.contain,
              // ),
              const SizedBox(width: 5),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}