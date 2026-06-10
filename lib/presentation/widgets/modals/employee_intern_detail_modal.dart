import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_intern.dart';
import 'package:zentinel/presentation/providers/logbook/logbook_provider.dart';
import 'package:zentinel/presentation/screens/employee/new_employee_movement_screen.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EmployeeInternDetailModal extends ConsumerWidget {
  final EmployeeIntern item;

  const EmployeeInternDetailModal({super.key, required this.item});


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
              'Detalle Personal Interno',
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
                    const SizedBox(height: 20),
                    detailRow('Nombres', item.names),
                    detailRow('Apellidos', item.lastname),
                    detailRow('Cédula', item.dni),
                    detailRow('Usuario', item.nameUser),
                    detailRow('Cargo', item.position),
                    detailRow('Finca', item.groupName),
                    detailRow('Estado', item.status),
                    detailRow('Observaciones', item.observations),
                    detailRow('Creado por', item.createdBy),
                    detailRow(
                      'Fecha Creación',
                      formatDateDetails(item.createdAt.toString()),
                    ),
                    detailRow('Actualizado por', item.updatedBy),
                    detailRow(
                      'Fecha Actualización',
                      formatDateDetails(item.updatedAt.toString()),
                    ),

                    if (item.photo != null)
                      ImagesGrid(
                        title: 'Foto personal',
                        images: [item.photo],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

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
            //         context.push('/list-employee-movements', extra: {
            //           "id_employee": item.idEmployeeIntern,
            //         });
            //     },
            //     child: const Text(
            //       'Ver Historial de movimientos',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),

            if (item.lastStatusMovement == 'Salida' || item.lastStatusMovement == 'Movimiento interno')
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
                      context.push('/new-employee-movement', 
                        extra: EmployeeMovementArgs(
                          idEmployee: item.idEmployeeIntern,
                          typeMovement: 'CHECK_IN',
                        )
                      );
                  },
                  child: const Text(
                    'Ingreso',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

            if (item.lastStatusMovement == 'Ingreso') ...[
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
                      context.push('/new-employee-movement', 
                        extra: EmployeeMovementArgs(
                          idEmployee: item.idEmployeeIntern,
                          typeMovement: 'TRANSFER',
                        )
                      );
                  },
                  child: const Text(
                    'Movimiento interno',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

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
                      context.push('/new-employee-movement',
                        extra: EmployeeMovementArgs(
                          idEmployee: item.idEmployeeIntern,
                          typeMovement: 'CHECK_OUT',
                        )
                      );
                  },
                  child: const Text(
                    'Salida',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],

            // const SizedBox(height: 10),

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
            //       if (isLoading) return;

            //       final option = await OptionBottomSheet.show<String>(
            //         context,
            //         title: 'Seleccionar movimiento',
            //         options: [
            //           if (item.lastStatusMovement == 'Salida' || item.lastStatusMovement == 'Movimiento interno')
            //             BottomSheetOption(
            //               value: 'INTERNAL_TRANSFER',
            //               label: 'Ingreso',
            //               icon: Icons.swap_horiz,
            //             ),

            //           if (item.lastStatusMovement == 'Ingreso') ...[
            //             BottomSheetOption(
            //               value: 'INTERNAL_TRANSFER',
            //               label: 'Movimiento interno',
            //               icon: Icons.swap_horiz,
            //             ),
            //             BottomSheetOption(
            //               value: 'END_SHIFT',
            //               label: 'Salida',
            //               icon: Icons.logout,
            //             ),
            //           ],
            //         ],
            //       );

            //       print(option);

            //       if (option == null) return;

            //       GlobalLoadingBottomSheet.show(
            //         status: OverlayStatus.loading, 
            //         message: "Actualizando personal..."
            //       );

            //       final response = await ref.read(saveEmployeeInternProvider.notifier).saveEmployeeMovement(
            //         {
            //           "employeeId": item.idEmployeeIntern,
            //           "movementType": option,
            //         }
            //       );
                  
            //       if (response.success) {
            //         GlobalLoadingBottomSheet.show(
            //           status: OverlayStatus.success, 
            //           message: "Despacho guardado exitosamente", 
            //           autoDismiss: const Duration(seconds: 2)
            //         );
            //         // ref.read(getHistoryDispatch.notifier).load();
            //       } else {
            //         GlobalLoadingBottomSheet.show(
            //           status: OverlayStatus.error,
            //           message: 'Error: ${response.message ?? 'Error al guardar el despacho. La información se guardará localmente y se enviará automáticamente.'}',
            //           autoDismiss: const Duration(seconds: 3),
            //         );

            //       }

            //       if (context.mounted) {
            //         Navigator.pop(context);
            //       }
                
            //     },

            //     child: const Text(
            //       'Más Opciones...',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
