import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/employee_movement.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:animate_do/animate_do.dart';

class EmployeeMovementList extends ConsumerStatefulWidget {
  final List<EmployeeMovement> items;
  final Future<void> Function(DateTimeRange? range, int page, bool append)? onFilterDate;

  const EmployeeMovementList({super.key, required this.items, this.onFilterDate});

  @override
  ConsumerState<EmployeeMovementList> createState() => EmployeeMovementListState();
}

class EmployeeMovementListState extends ConsumerState<EmployeeMovementList> {
  final ScrollController _scrollController = ScrollController();
  late List<EmployeeMovement> _filteredItems;
  bool _isLoading = false;
  DateTimeRange? _currentRange;
  int _page = 1;
  bool _isFetchingMore = false;
  bool _loadMoreData = true;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EmployeeMovementList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() {
        _filteredItems = List.from(widget.items);
      });
    }else {
      print('No se actualizó la lista de items');
      setState(() {
        _loadMoreData = false;
      });
    }
  }

  List<EmployeeMovement> _filterItemsByDateRange(DateTimeRange range) {
    return _filteredItems.where((item) {
      final itemDate = item.createdAt;

      final itemDateTime = itemDate;

      return itemDateTime.isAfter(range.start) &&
        itemDateTime.isBefore(range.end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _isLoading
        ? List.generate(5, (_) => null) // Placeholder para skeletons
        : (_currentRange != null
              ? _filterItemsByDateRange(_currentRange!)
              : _filteredItems);

    final displayItems = _currentRange != null
        ? items
        : items.take(items.length).toList();

    if (!_isLoading && _filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'No hay registros',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // Contar items totales incluyendo el loader si está fetching
    final totalItems = displayItems.length + (_isFetchingMore ? 1 : 0);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Skeletonizer(
            enabled: _isLoading,
            enableSwitchAnimation: true,
            ignorePointers: _isLoading,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                // Mostrar loading icon al final si está fetching más
                if (_isFetchingMore && index == displayItems.length) {
                  return _buildLoadingIndicator();
                }

                if (_isLoading) {
                  return _buildSkeletonCard();
                }

                final item = displayItems[index];

                if (item == null) {
                  return _buildSkeletonCard();
                }

                // final isEntry = item.recordType == 'entry';
                // final typeText = isEntry ? 'ingreso' : 'salida';

                final createdBy = item.nameUser;

                final description = 'Bitácora en ${item.groupName}';

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
                      child: EmployeeMovementDetailModal(item: item),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Información
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  createdBy,
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
                                  description,
                                  style: Theme.of(context).textTheme.bodySmall
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
                                  style: Theme.of(context).textTheme.bodySmall
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
                            backgroundColor: getStatusColorBckgEntry(
                              item.status,
                            ),
                            padding: EdgeInsets.zero,
                            labelStyle: TextStyle(
                              color: getStatusColorEntryAccess(item.status),
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

          // Fixed button at bottom center
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final range = await ModalHelper.open(
                      context,
                      child: DateRangePicker(
                        initialStart: _currentRange?.start,
                        initialEnd: _currentRange?.end,
                        onApply: (start, end) {
                          if (start != null && end != null) {
                            Navigator.of(
                              context,
                            ).pop(DateTimeRange(start: start, end: end));
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );

                    if (range != null) {
                      // Detectar si el usuario presionó "Limpiar" (marcador especial: año 1969)
                      final isClearAction = range.start.year == 1969;

                      if (isClearAction) {
                        // Usuario presionó "Limpiar"
                        setState(() {
                          _isLoading = true;
                          _currentRange = null;
                          _page = 1;
                          _loadMoreData = true;
                          _filteredItems = List.from(widget.items);
                        });

                        await widget.onFilterDate?.call(null, _page, false);

                        if (!mounted) return;

                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        // Usuario presionó "Ver registros"
                        setState(() {
                          _isLoading = true;
                          _currentRange = range;
                          _page = 1;
                          _loadMoreData = true;
                        });

                        await widget.onFilterDate?.call(range, _page, false);

                        if (!mounted) return;

                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(189, 21, 139, 139),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            46,
                            175,
                            132,
                          ).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _currentRange != null
                              ? _formatDateRangeLabel()
                              : 'Filtrar por fechas',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRangeLabel() {
    if (_currentRange == null) return 'Filtrar por fechas';
    
    final f = DateFormat('dd/MM');
    final start = f.format(_currentRange!.start);
    final end = f.format(_currentRange!.end);
    
    return '$start - $end';
  }

  Future<void> _onScroll() async {
    print(_loadMoreData);
    if (_isFetchingMore || _isLoading ) return;

    // Verificar si el scroll ha llegado al final (200px antes)
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 70) {
      setState(() {
        _isFetchingMore = true;
      });

      try {
        _page++;

        // Siempre llamar a onFilterDate para cargar más registros
        // Si hay filtro de fecha, se usa; si no, se carga sin filtro
        if (_currentRange != null) {
          await widget.onFilterDate?.call(_currentRange!, _page, true);
        } else {
          // Llamar al callback sin filtro de fecha
          await widget.onFilterDate?.call(
            null,
            _page,
            true,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isFetchingMore = false;
          });
        }
      }
    }
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 150, color: Colors.grey[700]),
                const SizedBox(height: 8),
                Container(height: 12, width: 200, color: Colors.grey[700]),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: Colors.grey[700]),
                const SizedBox(height: 8),
                Container(height: 20, width: 80, color: Colors.grey[700]),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 20, height: 20, color: Colors.grey[700]),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Spin(
          duration: const Duration(seconds: 2),
          infinite: true,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.sync,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
