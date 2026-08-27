import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/widgets/modals/task_filters_modal.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  static const name = 'task-list-screen';
  final bool isSupport;

  const TaskListScreen({super.key, required this.isSupport});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String searchText = '';
  Set<int> _selectedClientIds = <int>{};
  Set<int> _selectedLocationIds = <int>{};
  bool _isLoadingTasks = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  Map<String, dynamic> _buildFilters() {
    final filters = <String, dynamic>{'support': widget.isSupport};

    final authState = ref.read(userSessionProvider);
    final userData = authState.valueOrNull;

    if (userData?.role == 'tecnico') {
      filters['tech_assignments'] = [userData!.idUser];
    }

    if (_selectedClientIds.isNotEmpty) {
      filters['clients'] = _selectedClientIds.join(', ');
    }

    if (_selectedLocationIds.isNotEmpty) {
      filters['locations'] = _selectedLocationIds.join(', ');
    }

    return filters;
  }

  Future<void> _loadTasks() async {
    if (mounted) {
      setState(() => _isLoadingTasks = true);
    }

    try {
      await ref.read(getTaskTechnical.notifier).load(filters: _buildFilters());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo actualizar la lista. Intente nuevamente.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingTasks = false);
      }
    }
  }

  Future<void> _openFilters() async {
    final selection = await ModalHelper.open<TaskFilterSelection>(
      context,
      child: TaskFiltersModal(
        initialClientIds: _selectedClientIds,
        initialLocationIds: _selectedLocationIds,
      ),
    );

    if (selection == null || !mounted) return;

    setState(() {
      _selectedClientIds = selection.clientIds;
      _selectedLocationIds = selection.locationIds;
    });

    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final employeeInterns = ref.watch(getTaskTechnical);
    final filtered = employeeInterns.where((item) {
      final text = searchText.toLowerCase();

      final names = (item.name).toLowerCase();
      final code = (item.code).toLowerCase();

      return names.contains(text) || code.contains(text);
    }).toList();
    final activeFilterCount =
        _selectedClientIds.length + _selectedLocationIds.length;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(
          headerTxt: widget.isSupport ? 'Soportes' : 'Proyectos',
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
              Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 45,
                    child: FilledButton.icon(
                      onPressed: _isLoadingTasks ? null : _openFilters,
                      icon: const Icon(Icons.tune, size: 18),
                      label: Text(
                        activeFilterCount == 0
                            ? 'Filtros'
                            : 'Filtros ($activeFilterCount)',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          189,
                          21,
                          139,
                          139,
                        ),
                        disabledBackgroundColor: Colors.white12,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white38,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: _isLoadingTasks
                    ? Skeletonizer(
                        enabled: true,
                        enableSwitchAnimation: true,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (_, _) => _buildSkeletonTaskCard(),
                        ),
                      )
                    : filtered.isEmpty
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
                                child: TaskDetailModal(
                                  item: item,
                                  isSupport: widget.isSupport,
                                ),
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
                                            item.code,
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
                                        color: getColorTxtTaskTech(item.status),
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

  Widget _buildSkeletonTaskCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 180, color: Colors.white24),
                const SizedBox(height: 8),
                Container(height: 12, width: 110, color: Colors.white24),
                const SizedBox(height: 8),
                Container(height: 12, width: 90, color: Colors.white24),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            height: 28,
            width: 78,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }
}
