import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Logo
            Image.asset(
              'lib/assets/images/zentinel-logo.png',
              width: 140,
              height: 36,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(Icons.help_outline, color: Colors.white),
              ),
            ),

            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.search, color: Colors.white),
            //   padding: EdgeInsets.zero,
            //   constraints: const BoxConstraints(),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.help_outline, color: Colors.white),
            //   padding: EdgeInsets.zero,
            //   constraints: const BoxConstraints(),
            // ),
            const SizedBox(width: 3),
            // const Text('Ayuda', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
