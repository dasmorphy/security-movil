import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/technical_record.dart';
import 'package:zentinel/presentation/widgets/logbook/detail_row.dart';
import 'package:zentinel/presentation/widgets/technical/record_technical_header.dart';

class TechnicalRecordDetailModal extends StatelessWidget {
  final TechnicalRecord item;

  const TechnicalRecordDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final staffNames =
        item.technicalStaff
            ?.map((staff) => staff.name)
            .whereType<String>()
            .where((name) => name.isNotEmpty)
            .join(', ') ??
        '';
    final materials =
        item.materials
            ?.map((material) {
              final name = material.material ?? 'Material';
              final quantity = material.quantity;
              return quantity == null ? name : '$name ($quantity)';
            })
            .join(', ') ??
        '';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detalle del registro técnico',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    detailRow('Código de tarea', item.taskCode),
                    detailRow('Cliente', item.clientName),
                    detailRow('Ubicación', item.locationName),
                    detailRow('Estado', item.status),
                    detailRow('Creado por', item.createdBy),
                    detailRow('Fecha de creación', formatDate(item.createdAt)),
                    if (item.vehicle != null && item.vehicle.toString().isNotEmpty)
                      detailRow('Vehículo', item.vehicle.toString()),
                    if (materials.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Materiales',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              materials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (staffNames.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal técnico',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              staffNames,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (item.resume.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resumen',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item.resume,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (item.status == 'Incompleto')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                  onPressed: () => context.push('/new-task-technical', extra: {
                    'taskHeader': TechTaskHeader(
                      client: item.clientName, 
                      codeTask: item.taskCode, 
                      location: item.locationName, 
                      createdBy: item.createdBy, 
                      cliendId: item.clientId, 
                      locationId: item.locationId, 
                      taskId: item.taskId
                    ),
                    'registerIcompleted': item
                  }),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
