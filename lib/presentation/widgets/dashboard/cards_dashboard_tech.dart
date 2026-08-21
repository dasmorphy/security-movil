import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/graph_technical.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class CardsDashboardTech extends ConsumerWidget {
  const CardsDashboardTech({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(graphTechnicalProvider);

    if (data == null) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildStatusCard(
            data,
            label: 'Finalizado',
            icon: Icons.addchart_rounded,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  data,
                  label: 'En ejecución',
                  borderColor: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  data,
                  label: 'Aprobado',
                  borderColor: const Color.fromARGB(255, 11, 126, 202),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    GraphTechnical data, {
    required String label,
    Color? borderColor,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.all(icon == null ? 16 : 20),
      decoration: _cardDecoration(borderColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatNumber(_getCountByStatus(data, label)),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: icon == null ? 26 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (icon != null)
            Icon(
              icon,
              size: 40,
              color: const Color.fromARGB(255, 78, 224, 176),
            ),
        ],
      ),
    );
  }

  int _getCountByStatus(GraphTechnical data, String status) {
    for (final item in data.countStatus ?? const <CountStatus>[]) {
      if (item.status == status) return item.count ?? 0;
    }
    return 0;
  }

  BoxDecoration _cardDecoration(Color? colorBorder) {
    return BoxDecoration(
      color: const Color(0xFF1C1C1E),
      borderRadius: BorderRadius.circular(20),
      border: colorBorder != null
          ? Border(left: BorderSide(color: colorBorder, width: 3))
          : null,
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ",",
    );
  }
}
