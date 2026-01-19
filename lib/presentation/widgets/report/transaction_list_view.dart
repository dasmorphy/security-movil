import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/presentation/widgets/report/date_range_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  String _selectedDays = '15 días';
  String _selectedCategory = '0';
  String _test = '0';
  bool _isLoading = false; // ✅ AGREGA ESTO
  DateTimeRange? _currentRange;

  final TextEditingController _searchController = TextEditingController();

  // Datos de ejemplo - lista simple de transacciones
  final List<Transaction> _transactionsByDate = [
    Transaction(
      title: 'Reporte diario totalizado',
      subtitle: '16/01/2026',
      amount: '4080',
    ),
    Transaction(
      title: 'Reporte diario totalizado',
      subtitle: '15/01/2025',
      amount: '10k',
    ),
    Transaction(
      title: 'Reporte diario totalizado',
      subtitle: '14/01/2025',
      amount: '4050',
    ),
    Transaction(
      title: 'Reporte diario totalizado',
      subtitle: '13/01/2025',
      amount: '1500',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Skeletonizer(
            enabled: _isLoading,
            enableSwitchAnimation: true,
            ignorePointers: _isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSearchHeader(),
                  const SizedBox(height: 20),

                  ..._buildTransactionsList(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Fixed blue box at bottom center
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final range = await _openModal(
                        context,
                        DateRangePicker(
                          onApply: (start, end) {
                            print('DDDDDDDDD');

                            print(start);
                            print(end);
                            Navigator.of(context).pop();
                          },
                        ),
                        null,
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
                            _transactionsByDate.clear();
                            _transactionsByDate.addAll(
                              _mockFetchByRange(range),
                            );
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
                        color: const Color(0xFF2D77C9),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              143,
                              15,
                              15,
                            ).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today, color: Colors.white),
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
                ),

                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> _mockFetchByRange(DateTimeRange range) {
    return [
      Transaction(
        title: 'Reporte filtrado',
        subtitle:
            '${DateFormat('dd/MM/yyyy').format(range.start)} - ${DateFormat('dd/MM/yyyy').format(range.end)}',
        amount: '999',
      ),
    ];
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(width: 12), _buildCategoryDropdown()],
        ),
      ),
    );
  }

  List<Widget> _buildTransactionsList() {
    if (_isLoading) {
      return List.generate(5, (_) => _buildSkeletonCard());
    }

    return _transactionsByDate.map((transaction) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: _buildTransactionCard(transaction),
      );
    }).toList();
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 180, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 120, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(height: 20, width: 50, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 220,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 220, // ajusta a tu diseño
              child: Text(
                'Reportes totalizados ',
                textAlign: TextAlign.left,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),
      ],
    );
  }

  Future<DateTimeRange?> _openModal(
    BuildContext context,
    Widget childWidget,
    double? height,
  ) async {
    final double heightModal =
        height ?? MediaQuery.of(context).size.height * 0.89;

    return await showMaterialModalBottomSheet<DateTimeRange>(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      duration: const Duration(milliseconds: 600),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: SizedBox(height: heightModal, child: childWidget),
      ),
    );
  }
}

class Transaction {
  final String title;
  final String subtitle;
  final String amount;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}
