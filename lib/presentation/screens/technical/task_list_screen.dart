import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  static const name = 'task-list-screen';

  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() =>
      _TaskListScreenState();
}

class _TaskListScreenState
    extends ConsumerState<TaskListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getTaskTechnical.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeInterns = ref.watch(getTaskTechnical);
    final filtered = employeeInterns.where((item) {
      final text = searchText.toLowerCase();

      final names = (item.name).toLowerCase();
      final code = (item.code).toLowerCase();

      return names.contains(text) ||
          code.contains(text);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Tareas'),
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
                                child: TaskDetailModal(item: item),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Cédula',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: const Color.fromARGB(
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
                                                  color: const Color.fromARGB(
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
                                      label: Text(item.status),
                                      backgroundColor: getStatusColorTaskTech(
                                        item.status,
                                      ),
                                      padding: EdgeInsets.zero,
                                      labelStyle: TextStyle(
                                        color: getColorTxtTaskTech(
                                          item.status,
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
