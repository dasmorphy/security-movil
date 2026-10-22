import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/blacklist_driver.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListBlacklistDriver extends ConsumerStatefulWidget {
  final List<BlacklistDriver> items;
  final int? limit;

  const ListBlacklistDriver({super.key, required this.items, this.limit = 15});

  @override
  ConsumerState<ListBlacklistDriver> createState() => ListBlacklistDriverState();
}

class ListBlacklistDriverState extends ConsumerState<ListBlacklistDriver> {
  late List<dynamic> _filteredItems;
  bool _isLoading = false;
  DateTimeRange? _currentRange;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(ListBlacklistDriver oldWidget) {
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
      return Center(
        child: Text(
          'No hay registros',
          style: TextStyle(color: context.colors.textPrimary.withOpacity(0.7)),
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
                  final formattedDate = formatDate(item.createdAt);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () =>
                        ModalHelper.open(context, child: BlacklistDetailModal(item: item)),
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
                                    item.fullNames,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: context.colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),            
                                  Text(
                                    item.dni,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                              
                                  Text(
                                    formattedDate,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ],
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
                      color: context.colors.secondary,
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
                        Icon(
                          Icons.calendar_today,
                          color: context.colors.textPrimary,
                          size: 15,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Filtrar por fechas',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.colors.textPrimary,
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
        color: (context.isDarkMode ? Colors.grey[800] : Colors.grey[300]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200]),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 150, color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200])),
                const SizedBox(height: 8),
                Container(height: 12, width: 200, color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200])),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200])),
                const SizedBox(height: 8),
                Container(height: 20, width: 80, color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200])),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 20, height: 20, color: (context.isDarkMode ? Colors.grey[700] : Colors.grey[200])),
        ],
      ),
    );
  }
}
