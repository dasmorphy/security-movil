import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video de fondo
            // const AutoPlayLocalVideo(),

            // Contenido arriba
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/zentinel-logo.png',
                      width: 120,
                      height: 36,
                      fit: BoxFit.contain,
                    ),

                    const Spacer(),

                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ),

                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(Icons.help_outline, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
