import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeInternListScreen extends ConsumerStatefulWidget {
  static const name = 'employee-intern-list-screen';

  const EmployeeInternListScreen({super.key});

  @override
  ConsumerState<EmployeeInternListScreen> createState() =>
      _EmployeeInternListScreenState();
}

class _EmployeeInternListScreenState
    extends ConsumerState<EmployeeInternListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(userSessionProvider);

      if (!authState.hasValue || authState.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión no válida. Vuelva a iniciar sesión'),
          ),
        );
        return;
      }

      final userData = authState.value!;

      ref.read(getEmployeeInterns.notifier).load(
        filters: {
          "page": 1,
          "rows": 20,
          "id_group_business": userData.attributes['group_business'],
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeInterns = ref.watch(getEmployeeInterns);
    final filtered = employeeInterns.where((item) {
      final text = searchText.toLowerCase();

      final names = (item.names).toLowerCase();
      final lastname = (item.lastname).toLowerCase();
      final dni = (item.dni).toLowerCase();
      final position = (item.position).toLowerCase();

      return names.contains(text) ||
          lastname.contains(text) ||
          dni.contains(text) ||
          position.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(
          headerTxt: 'Personal Interno',
        ),
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
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay registros',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];

                          final formattedDate = formatDate(item.createdAt);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => ModalHelper.open(
                                context,
                                child:
                                    EmployeeInternDetailModal(item: item),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.names,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: const Color
                                                      .fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Cédula: ${item.dni}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: const Color
                                                      .fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            formattedDate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: const Color
                                                      .fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    ),
                                    Chip(
                                      side: BorderSide.none,
                                      label: Text(item.lastStatusMovement),
                                      backgroundColor:
                                          getStatusColorMovements(
                                            item.lastStatusMovement,
                                          ),
                                      padding: EdgeInsets.zero,
                                      labelStyle: TextStyle(
                                        color:
                                            getColorTxtMovements(
                                              item.lastStatusMovement,
                                            ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
