import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/all_round.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class RoundDetailModal extends ConsumerWidget {
  final AllRound item;

  const RoundDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Text(
              'Detalle Ronda',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// ENTRADA
                    RoundDetail(item: item),

                    /// IMÁGENES ENTRADA
                    if (item.images.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes',
                        images: item.images,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF444444),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}