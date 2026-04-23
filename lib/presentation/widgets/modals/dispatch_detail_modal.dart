import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class DispatchDetailModal extends ConsumerStatefulWidget {
  final AllDispatch item;

  const DispatchDetailModal({super.key, required this.item});

  @override
  ConsumerState<DispatchDetailModal> createState() =>
      DispatchDetailModalState();
}

class DispatchDetailModalState extends ConsumerState<DispatchDetailModal> {

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
    final imgSaveDispatch = widget.item.images.where((img) => img.process == 'save_dispatch').toList();
    final imgUpdateDispatch = widget.item.images.where((img) => img.process == 'update_dispatch').toList();
    final imgSaveReception = widget.item.images.where((img) => img.process == 'save_reception').toList();


    final authState = ref.watch(userSessionProvider);

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
                    ItemDetailDispatch(item: widget.item),

                    if (imgSaveDispatch.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes despacho',
                        images: imgSaveDispatch.map((img) => img.imagePath).toList(),
                      ),

                    if (imgUpdateDispatch.isNotEmpty)
                      ImagesGrid(
                        title: 'Salida despacho',
                        images: imgUpdateDispatch.map((img) => img.imagePath).toList(),
                      ),

                    if (imgSaveReception.isNotEmpty)
                      ImagesGrid(
                        title: 'Imágenes recepción',
                        images: imgSaveReception.map((img) => img.imagePath).toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOTON CAMBIO DE ESTADO EN TRANSITO
            if (widget.item.status == 'Listo para despacho' && userData.hasPermission(Permissions.despachoCambioEstadoTransito))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/update-status-dispatch', extra: widget.item),
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
                        'Actualizar estado',
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

            // BOTON CONFIRMAR RECEPCION
            if (widget.item.status == 'En tránsito' && userData.hasPermission(Permissions.despachoCambioEstadoRecepcion))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/confirm-dispatch', extra: widget.item),
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
                        'Confirmar recepción',
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
