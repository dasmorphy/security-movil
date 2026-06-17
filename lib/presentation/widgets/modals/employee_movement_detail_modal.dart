import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/screens/screens.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EmployeeMovementDetailModal extends ConsumerWidget {
  final EmployeeMovement item;
  final bool? isDataEmployee;

  const EmployeeMovementDetailModal({super.key, required this.item, this.isDataEmployee = false});

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
              'Detalle Movimiento Personal',
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
                    detailRow('Nombres', item.employeeNames),
                    detailRow('Apellidos', item.employeeLastname),
                    detailRow('Cédula', item.employeeDni),
                    detailRow('Guía', item.shippingGuide),
                    detailRow('Finca', item.groupName),
                    detailRow('Otro destino', item.otherDestiny),
                    detailRow('Motivo', item.reasonOut),
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

                    if (item.images.isNotEmpty)
                      ImagesGrid(title: 'Imágenes', images: item.images),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (isDataEmployee != true)...[
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
                        if (userData.hasPermission(Permissions.nuevoMovimientoPersonalInterno))...[
                          if (item.status != 'Ingreso')
                            BottomSheetOption(
                              value: 'CHECK_IN',
                              label: 'Ingreso',
                              icon: Icons.swap_horiz,
                            ),

                          if (item.status == 'Ingreso')...[
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
                      ],
                    );

                    if (option == null) return;
                    if (!context.mounted) return;

                    if (option == 'CHECK_IN') {
                      context.push(
                        '/new-employee-movement',
                        extra: EmployeeMovementArgs(
                          idEmployee: item.employeeId,
                          typeMovement: 'CHECK_IN',
                        ),
                      );
                    }

                    if (option == 'TRANSFER') {
                      context.push(
                        '/new-employee-movement',
                        extra: EmployeeMovementArgs(
                          idEmployee: item.employeeId,
                          typeMovement: 'TRANSFER',
                        ),
                      );
                    }

                    if (option == 'CHECK_OUT') {
                      context.push(
                        '/new-employee-movement',
                        extra: EmployeeMovementArgs(
                          idEmployee: item.employeeId,
                          typeMovement: 'CHECK_OUT',
                        ),
                      );
                    }
                  },

                  child: const Text(
                    'Más Opciones...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]
            else...[
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
            ],

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
