import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class UpdateStatusDispatch extends ConsumerStatefulWidget {
  final AllDispatch item;

  const UpdateStatusDispatch({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<UpdateStatusDispatch> createState() => _UpdateStatusDispatchState();
}

class _UpdateStatusDispatchState extends ConsumerState<UpdateStatusDispatch> {
  bool imagesMinError = false;
  bool imagesMaxError = false;
  bool _isLoading = false;
  List<Uint8List?> _selectedImages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dispatchStatus = ref.watch(getDispatchStatus);
    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    final userData = authState.value!;

    Future<ApiResponse> updateDispatchStatus(int statusId) async {
      final updateDispatchProvider = ref.read(dispatchProvider.notifier);
      return await updateDispatchProvider.updateDispatch({
        'dispatch_id': widget.item.idDispatch,
        'status_id': statusId,
        'user': userData.user,
        'images': _selectedImages.whereType<Uint8List>().toList(),
      });
    }

    void changeStatus() async {
      setState(() => _isLoading = true);

      try {
        final statusChange = dispatchStatus.where(
          (statusList) =>
          statusList.name.toLowerCase() == 'En tránsito'.toLowerCase(),
        );

        if (statusChange.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se encontró el estado "En tránsito".'),
            ),
          );
          return;
        }

        final confirmed = await ConfirmBottomSheet.show(
          context,
          title: "Actualizar estado",
          message: "Se actualizará el estado del despacho a 'En tránsito'. ¿Desea continuar?",
        );

        if (confirmed == true) {
          GlobalLoadingBottomSheet.show(
            status: OverlayStatus.loading, 
            message: "Actualizando estado..."
          );

          final response = await updateDispatchStatus(statusChange.first.idStatus);

          if (!mounted) return;
          setState(() => isLoading = false);

          if (response.success) {
            GlobalLoadingBottomSheet.show(
              status: OverlayStatus.success, 
              message: "Estado actualizado exitosamente", 
              autoDismiss: const Duration(seconds: 2)
            );
            ref.read(getHistoryDispatch.notifier).load();
            Navigator.of(context).pop();
          } else {
            GlobalLoadingBottomSheet.show(
              status: OverlayStatus.error,
              message: 'Error: ${response.message ?? 'Error al actualizar el estado'}',
              autoDismiss: const Duration(seconds: 3),
            );
          }


        }

      } catch (e) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error al actualizar estado: $e',
          autoDismiss: const Duration(seconds: 3),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Actualizar despacho',)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del despacho
              DispatchInfoCard(
                dispatchId: widget.item.idDispatch,
                orderNumber: widget.item.orderNumber,
                destiny: widget.item.nameDestiny,
                driver: widget.item.driver,
                status: widget.item.status,
                statusColor: getStatusColorDispatch(widget.item.status),
              ),

              const SizedBox(height: 24),

              // Título de artículos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Materiales / Equipos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.item.productsSku.length} Material(es)',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lista de productos
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.item.productsSku.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final material = widget.item.productsSku[index];
                  return FinishMaterialItemCard(
                    materialName: material.name,
                    quantity: material.quantity,
                  );
                },
              ),

              const SizedBox(height: 20),

              CameraImagePicker(
                minImages: 5,
                maxImages: 10,
                onImagesChanged: (images) {
              
                  print("imagenes seleccionadas ${images.length}");
              
                  _selectedImages = images;
              
                },
              ),

              const SizedBox(height: 16),

              if (imagesMinError || imagesMaxError)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      imagesMinError
                          ? 'Debe subir mínimo 5 imagenes'
                          : 'Debe subir máximo 10 imagenes',
                      style: TextStyle(color: Color.fromARGB(255, 239, 28, 13)),
                    ),
                  ),
                  const SizedBox(height: 12,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : changeStatus,
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
                      if (_isLoading) ...[
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
