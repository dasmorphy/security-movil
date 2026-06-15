import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeMovementScreen extends ConsumerStatefulWidget {
  static const name = 'employee-movement-screen';
  final dynamic filtersMovement;
  final bool? isDataEmployee;

  const EmployeeMovementScreen({super.key, this.filtersMovement, this.isDataEmployee = false});

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
    final authState = ref.watch(userSessionProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    final userData = authState.value!;

    if (widget.filtersMovement != null && widget.filtersMovement['id_employee'] != null){
      ref.read(getEmployeeMovementsById.notifier).load(
        filters:{
          "page": 1,
          "rows": 20,
          if (widget.filtersMovement != null)
            "id_employee": widget.filtersMovement['id_employee'],
        }
      );
    }else{
      ref.read(getEmployeeMovements.notifier).load(
        filters:{
          "page": 1,
          "rows": 20,
          "type_movement": "TRANSFER",
          "group_business_id": userData.attributes['group_business']
        }
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    List<EmployeeMovement> employeeInterns = [];

    if (widget.filtersMovement != null && widget.filtersMovement['id_employee'] != null){
      employeeInterns = ref.watch(getEmployeeMovementsById);
    }else{
      employeeInterns = ref.watch(getEmployeeMovements);
    }



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
