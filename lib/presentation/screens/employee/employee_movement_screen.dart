import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeMovementScreen extends ConsumerStatefulWidget {
  static const name = 'employee-movement-screen';

  const EmployeeMovementScreen({super.key});

  @override
  ConsumerState<EmployeeMovementScreen> createState() =>
      _EmployeeMovementScreenState();
}

class _EmployeeMovementScreenState
    extends ConsumerState<EmployeeMovementScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    ref.read(getEmployeeMovements.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final employeeInterns = ref.watch(getEmployeeMovements);
    final filtered = employeeInterns.where((item) {
      final text = searchText.toLowerCase();

      final names = (item.employeeNames).toLowerCase();
      final lastname = (item.employeeLastname).toLowerCase();
      final dni = (item.employeeDni).toLowerCase();

      return names.contains(text) ||
          lastname.contains(text) ||
          dni.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Movimientos de personal'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Expanded(
                child: EmployeeMovementList(
                  items: employeeInterns,
                  onFilterDate: (range, page, append) async {
                    DateTime? endDate;

                    if (range != null) {
                      endDate = DateTime(
                        range.end.year,
                        range.end.month,
                        range.end.day,
                        23,
                        59,
                        59,
                      );
                    }
                    await ref.read(getEmployeeMovements.notifier).load(
                      filters: {
                        "page": page,
                        "rows": 20,

                        if (range != null)
                          "start_date": range.start.toIso8601String(),

                        if (endDate != null)
                          "end_date": formatDateToApi(endDate),
                      },

                      append: append,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
