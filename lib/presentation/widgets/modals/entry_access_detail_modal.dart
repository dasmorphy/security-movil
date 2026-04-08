import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/entry_access_control.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EntryAccessDetailModal extends ConsumerStatefulWidget {
  final EntryAccessControl item;

  const EntryAccessDetailModal({super.key, required this.item});

  @override
  ConsumerState<EntryAccessDetailModal> createState() =>
      EntryAccessDetailModalState();
}

class EntryAccessDetailModalState extends ConsumerState<EntryAccessDetailModal> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);
    final imgEntry = widget.item.images.where((img) => img.typeProcess == 'entry').toList();
    final imgOut = widget.item.images.where((img) => img.typeProcess == 'out').toList();

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Text(
              'Detalle',
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
                    ItemDetailEntry(item: widget.item),

                    if (imgEntry.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes entrada',
                        images: imgEntry.map((img) => img.imagePath).toList(),
                      ),

                    if (imgOut.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes salida',
                        images: imgOut.map((img) => img.imagePath).toList(),
                      ),

                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // BOTON CONFIRMAR RECEPCION
            if (widget.item.status == 'Pendiente Salida' && userData.hasPermission(Permissions.finalizarIngresoBiomar))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/finish-entry-access', extra: widget.item),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color.fromARGB(189, 7, 213, 213),
                    disabledBackgroundColor: const Color.fromARGB(
                      120,
                      7,
                      213,
                      213,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Finalizar',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
