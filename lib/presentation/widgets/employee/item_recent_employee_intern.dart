import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ItemRecentEmployeeMovement extends ConsumerWidget {
  final List<EmployeeMovement>? itememployeeMovements;
  const ItemRecentEmployeeMovement({super.key, required this.itememployeeMovements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeMovements = ref.watch(getEmployeeMovements);
    final limitedList = employeeMovements.take(5).toList();

    if (employeeMovements.isEmpty) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: List.generate(limitedList.length, (index) {
        final item = limitedList[index];
        final formattedDate = formatDate(item.createdAt);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => ModalHelper.open(
              context,
              child: EmployeeMovementDetailModal(item: item),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.employeeNames} ${item.employeeLastname}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),

                        Text(
                          item.employeeStatus,
                          style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(
                              color: const Color.fromARGB(255, 180, 180, 180),
                            ),
                        ),
                        const SizedBox(height: 2),

                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color.fromARGB(255, 180, 180, 180),
                              ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),

                  Chip(
                    side: BorderSide.none,
                    label: Text(item.status),
                    backgroundColor: getStatusColorMovements(item.status),
                    padding: EdgeInsets.zero,
                    labelStyle: TextStyle(
                      color: getColorTxtMovements(item.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
