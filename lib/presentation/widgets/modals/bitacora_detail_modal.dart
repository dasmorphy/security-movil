import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BitacoraDetailModal extends ConsumerWidget {
  final AllLogbook item;

  const BitacoraDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryImages = item.imagesEntry ?? [];
    final outImages = item.out?.imagesOut ?? item.imagesOut ?? [];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Text(
              'Detalle Bitácora',
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
                    if (item.idLogbookEntry != null) EntryDetails(item: item),

                    /// IMÁGENES ENTRADA
                    if (entryImages.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes Ingreso',
                        images: entryImages,
                      ),

                    /// SALIDA
                    if (item.out != null || item.idLogbookOut != null)
                      OutDetails(out: item.out ?? item),

                    /// IMÁGENES SALIDA
                    if (outImages.isNotEmpty ||
                        (item.imagesOut != null && item.imagesOut!.isNotEmpty))
                      ImagesGrid(title: 'Imágenes Salida', images: outImages),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BOTÓN CONTINUAR
            if (item.status == 'Pendiente Salida')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(188, 25, 156, 156),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExitReportForm(
                          preloadedData: item,
                          onSubmit: (data) async {
                            return await ref
                                .read(saveOutLogbookProvider.notifier)
                                .saveLogbookOut(data);
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

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