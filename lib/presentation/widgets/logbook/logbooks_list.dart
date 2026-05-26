import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LogbooksList extends ConsumerStatefulWidget {
  final List<dynamic> items;
  final int? limit;

  const LogbooksList({super.key, required this.items, this.limit = 15});

  @override
  ConsumerState<LogbooksList> createState() => LogbooksListState();
}

class LogbooksListState extends ConsumerState<LogbooksList> {
  late List<dynamic> _filteredItems;
  bool _isLoading = false;
  DateTimeRange? _currentRange;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(LogbooksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  List<dynamic> _filterItemsByDateRange(DateTimeRange range) {
    return _filteredItems.where((item) {
      final itemDate = item.createdAt;
      if (itemDate == null) return false;

      final itemDateTime = itemDate is DateTime
          ? itemDate
          : DateTime.tryParse(itemDate.toString());
      if (itemDateTime == null) return false;

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
        : _filteredItems
      );

    final displayItems = _currentRange != null
      ? items
      : items.take(widget.limit ?? items.length).toList();

    if (!_isLoading && _filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'No hay registros',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Skeletonizer(
            enabled: _isLoading,
            enableSwitchAnimation: true,
            ignorePointers: _isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  if (_isLoading) {
                    return _buildSkeletonCard();
                  }

                  final item = displayItems[index];

                  final isEntry = item.idLogbookEntry != null;
                  final typeText = isEntry ? 'ingreso' : 'salida';

                  final createdBy = item.nameUser ?? 'Sin usuario';
                  final groupName = item.groupName ?? 'Sin grupo';

                  final description = 'Bitácora de $typeText en $groupName';

                  final formattedDate = formatDate(item.createdAt);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () =>
                          ModalHelper.open(context, child: BitacoraDetailModal(item: item)),
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
                                    style: Theme.of(context).textTheme.bodyMedium
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
                              backgroundColor: getStatusColorBckgEntry(item.status),
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
                        onApply: (start, end) {
                          Navigator.of(context).pop();
                        },
                      ),
                    );

                    if (range != null) {
                      setState(() {
                        _isLoading = true;
                        _currentRange = range;
                      });

                      // Simula llamada a API con filtros start/end
                      Future.delayed(const Duration(seconds: 2), () {
                        if (!mounted) return;

                        setState(() {
                          _isLoading = false;
                        });
                      });
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
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Filtrar por fechas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
}
