import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets.dart';
import 'transaction_list_view.dart';


class TotalReport extends ConsumerStatefulWidget {
  const TotalReport({super.key});

  @override
  TotalReportState createState() => TotalReportState();
}

class TotalReportState extends ConsumerState<TotalReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 📦 CONTENIDO DE LA PÁGINA
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                TransactionListView(),
              ],
            ),
          ),

          // 📋 LISTA DE TRANSACCIONES
        ],
      ),
    );
  }
}