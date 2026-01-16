import 'package:flutter/material.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  String _selectedDays = '15 días';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchHeader(),
          const SizedBox(height: 20),
          ..._buildTransactionsList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Expanded(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.circular(24),
          //     ),
          //     child: TextField(
          //       controller: _searchController,
          //       style: const TextStyle(color: Colors.white),
          //       decoration: InputDecoration(
          //         hintText: 'Buscar',
          //         hintStyle: TextStyle(color: Colors.grey[500]),
          //         border: InputBorder.none,
          //         icon: Icon(Icons.search, color: Colors.grey[500]),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(24),
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _selectedDays = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['7 días', '15 días', '30 días', '90 días']
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDays,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(24),
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _selectedDays = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['7 días', '15 días', '30 días', '90 días']
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDays,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.download, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionsList() {
    return _transactionsByDate.map((transaction) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _buildTransactionCard(transaction),
      );
    }).toList();
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 4),
              // Text(
              //   transaction.previousAmount,
              //   style: TextStyle(
              //     color: Colors.grey[400],
              //     fontSize: 12,
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
        ],
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
