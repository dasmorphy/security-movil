import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/domain/entities/api_response.dart';
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
    bool isLoading = false;
    final dispatchStatus = ref.watch(getDispatchStatus);

    final authState = ref.watch(userSessionProvider);

    if (!authState.hasValue || authState.value == null) {
      return const SizedBox.shrink();
    }

    // final userData = authState.value!;

    Future<ApiResponse> updateDispatchStatus(int statusId) async {
      final dispatchProvider = ref.read(updateDispatchProvider.notifier);
      return await dispatchProvider.updateDispatch({
        'dispatch_id': widget.item.idDispatch,
        'status_id': statusId,
        'user': authState.value!.user,
      });
    }

    void changeStatus() async {
      setState(() => isLoading = true);

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
          print(dispatchStatus);
          print('Elemento actualizado');

          // GlobalLoadingBottomSheet.show(
          //   message: "Actualizando estado...",
          // );
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
          } else {
            GlobalLoadingBottomSheet.show(
              status: OverlayStatus.error,
              message: 'Error: ${response.message ?? 'Desconocido'}',
              autoDismiss: const Duration(seconds: 3),
            );
          }

          Navigator.of(context).pop();

        }

      } catch (e) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error al actualizar estado: $e',
          autoDismiss: const Duration(seconds: 3),
        );
      }
    }

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
                  children: [ItemDetailDispatch(item: widget.item)],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BOTÓN CONTINUAR
            // if (item.status == 'Despachado' && userData.hasPermission(Permissions.nuevaBitacoraIngreso))
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color.fromARGB(188, 25, 156, 156),
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     onPressed: () async {
            //       await Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => ExitReportForm(
            //             preloadedData: item,
            //             onSubmit: (data) async {
            //               return await ref
            //                   .read(saveOutLogbookProvider.notifier)
            //                   .saveLogbookOut(data);
            //             },
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Text(
            //       'Continuar',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : changeStatus,
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
                    if (isLoading) ...[
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


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/confirm-dispatch', extra: widget.item),
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
