import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class ShipmentDispatch extends ConsumerWidget {
  const ShipmentDispatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(graphDispatchProvider);

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
          _buildTotalCard(data),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPendingCard(data)),
              const SizedBox(width: 12),
              Expanded(child: _buildTransitCard(data)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(GraphDispatch data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total despachos",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatNumber(data.totalRecords),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.addchart_rounded, 
            size: 40, 
            color: const Color.fromARGB(255, 78, 224, 176),
          )
        ],
      ),
    );
  }

  Widget _buildPendingCard(GraphDispatch data) {
    return Container(
      // height: 115,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(Colors.orange),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "En tránsito",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            data.getCountByStatus('En tránsito').toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildTransitCard(GraphDispatch data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(Color.fromARGB(255, 11, 126, 202)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Listo para despacho",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            data.getCountByStatus('Listo para despacho').toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
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
