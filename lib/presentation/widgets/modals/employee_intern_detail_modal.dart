import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_intern.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class EmployeeInternDetailModal extends StatelessWidget {
  final EmployeeIntern item;

  const EmployeeInternDetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
                  ],
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
