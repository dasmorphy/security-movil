import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/constants/permissions.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/task_technical.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class TaskDetailModal extends ConsumerWidget {
  final TaskTechnical item;
  final bool isSupport;

  const TaskDetailModal({super.key, required this.item, this.isSupport = false});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userSessionProvider);
    final userData = authState.value!;

    showConfirmationDialog(int taskId) async {
      final confirmed = await ConfirmBottomSheet.show(
        context,
        title: "Finalizar proyecto",
        message: "Se enviará la solicitud para finalización del proyecto. ¿Desea continuar?",
      );

      if (confirmed == true) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.loading, 
          message: "Enviando solicitud..."
        );

        final response =  await ref.read(technicalRecordProvider.notifier).updateStatusProject({
          "id_project": taskId,
          "new_status": "Pendiente aprobación",
          "user": userData.user,
          "notification_type": "TECHNICAL_REQUEST_APPROVAL"
        });

        if (response.success) {
          GlobalLoadingBottomSheet.show(
            status: OverlayStatus.success, 
            message: "Solicitud enviada exitosamente", 
            autoDismiss: const Duration(seconds: 2)
          );
          ref.read(getTaskTechnical.notifier).load(
            filters: {
              'support': isSupport
          });
          if (context.mounted) {
            context.pop();
          }
        } else {
          GlobalLoadingBottomSheet.show(
            status: OverlayStatus.error,
            message: 'Error: ${response.message ?? 'Error al enviar la solicitud'}',
            autoDismiss: const Duration(seconds: 3),
          );
        }
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
              'Detalle Proyecto',
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
                    detailRow('Nombres', item.name),
                    detailRow('Código tarea', item.code),
                    detailRow('Descripción', item.description),
                    detailRow('Estado', item.status),
                    detailRow('Creado por', item.createdBy),
                    detailRow(
                      'Fecha Creación',
                      formatDateDetails(item.createdAt.toString()),
                    ),

                    if (item.technicalsAssignments?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Técnicos asignados',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 8),

                            ...item.technicalsAssignments!.map((material) {
                              final name = material.fullnameUser ?? 'N/A';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),


                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                if (userData.hasPermission(Permissions.nuevaFiscalizacion))...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromARGB(188, 25, 156, 156)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        context.push('/auditing-record',
                          extra: TechTaskHeader(
                            taskId: item.idTask,
                            cliendId: item.clientId,
                            locationId: item.locationId,
                            client: item.client,
                            codeTask: item.code,
                            location: item.location,
                            createdBy: item.createdBy,
                          )
                        );
                      },
                      child: const Text(
                        'Fiscalización',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                if (userData.hasPermission(Permissions.solicitarFinalizacionProyecto) && 
                  item.status == 'En ejecución')...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromARGB(188, 25, 156, 156)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        showConfirmationDialog(item.idTask);
                      },
                      child: const Text(
                        'Solicitar finalización',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                if (userData.hasPermission(Permissions.nuevoRegistroTecnico)
                && item.status != 'Finalizado' && item.status != 'Pendiente aprobación')...[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(188, 25, 156, 156),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                          context.push('/new-task-technical',
                            extra: {
                              "taskHeader": TechTaskHeader(
                                taskId: item.idTask,
                                cliendId: item.clientId,
                                locationId: item.locationId,
                                client: item.client,
                                codeTask: item.code,
                                location: item.location,
                                createdBy: item.createdBy,
                              ),
                              "isSupport": isSupport
                            }
                          );
                      },
                      child: const Text(
                        'Registro',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],

              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
