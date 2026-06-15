import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_intern.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/screens/employee/new_employee_movement_screen.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EmployeeInternDetailModal extends ConsumerWidget {
  final EmployeeIntern item;

  const EmployeeInternDetailModal({super.key, required this.item});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userSessionProvider);
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
                    detailRow('Cargo', item.position),
                    detailRow('Finca', item.groupName),
                    detailRow('Estado', item.status),
                    detailRow('Observaciones', item.observations),
                    detailRow('Creado por', item.createdBy),
                    detailRow('Guardia', item.nameUser),
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
                    context.push('/list-employee-movements', extra: {
                      "id_employee": item.idEmployeeIntern,
                    });
                },
                child: const Text(
                  'Ver Historial de movimientos',
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
                  if (isLoading) return;

                  final option = await OptionBottomSheet.show<String>(
                    context,
                    options: [
                      if (userData.hasPermission(Permissions.nuevoMovimientoPersonalInterno) && item.status == 'Autorizado')...[
                        if (item.lastStatusMovement != 'Ingreso')
                          BottomSheetOption(
                            value: 'CHECK_IN',
                            label: 'Ingreso',
                            icon: Icons.swap_horiz,
                          ),

                        if (item.lastStatusMovement == 'Ingreso') ...[
                          BottomSheetOption(
                            value: 'TRANSFER',
                            label: 'Movimiento interno',
                            icon: Icons.swap_horiz,
                          ),
                          BottomSheetOption(
                            value: 'CHECK_OUT',
                            label: 'Salida',
                            icon: Icons.logout,
                          ),
                        ],
                      ],

                      if (userData.hasPermission(Permissions.actualizarEstadoPersonalInterno))
                        BottomSheetOption(
                          value: 'UPDATE_EMPLOYEE',
                          label: 'Actualizar estado personal',
                          icon: Icons.cached_sharp,
                        ),
                    ],
                  );

                  if (option == null) return;
                  if (!context.mounted) return;

                  if (option == 'CHECK_IN') {
                    context.push('/new-employee-movement', 
                      extra: EmployeeMovementArgs(
                        idEmployee: item.idEmployeeIntern,
                        typeMovement: 'CHECK_IN',
                      )
                    );
                    
                  }

                  if (option == 'TRANSFER') {
                    context.push('/new-employee-movement', 
                      extra: EmployeeMovementArgs(
                        idEmployee: item.idEmployeeIntern,
                        typeMovement: 'TRANSFER',
                      )
                    );
                  }

                  if (option == 'CHECK_OUT') {
                    context.push('/new-employee-movement',
                      extra: EmployeeMovementArgs(
                        idEmployee: item.idEmployeeIntern,
                        typeMovement: 'CHECK_OUT',
                      )
                    );
                  }

                  if (option == 'UPDATE_EMPLOYEE') {
                    final newStatus = item.status == 'Autorizado' ? 'No autorizado' : 'Autorizado';
                    final confirmed = await ConfirmBottomSheet.show(
                      context,
                      title: "Actualizar estado",
                      message: "Se actualizará el estado a '$newStatus'. ¿Desea continuar?",
                    );

                    if (confirmed == true) {
                      GlobalLoadingBottomSheet.show(
                        status: OverlayStatus.loading, 
                        message: "Actualizando estado..."
                      );

                      final response =  await ref.read(saveEmployeeInternProvider.notifier).updateStatusEmployeeIntern({
                        "id_employee": item.idEmployeeIntern,
                        "status": newStatus,
                        "user_update": userData.user
                      });

                      if (response.success) {
                        GlobalLoadingBottomSheet.show(
                          status: OverlayStatus.success, 
                          message: "Estado actualizado exitosamente", 
                          autoDismiss: const Duration(seconds: 2)
                        );
                        ref.read(getEmployeeInterns.notifier).load();
                        if (context.mounted) {
                          context.pop();
                        }
                      } else {
                        GlobalLoadingBottomSheet.show(
                          status: OverlayStatus.error,
                          message: 'Error: ${response.message ?? 'Error al actualizar el estado'}',
                          autoDismiss: const Duration(seconds: 3),
                        );
                      }

                    }
                  }
                },

                child: const Text(
                  'Más Opciones...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
