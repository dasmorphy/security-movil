import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';

class ShipmentDispatch extends StatelessWidget {
  final GraphDispatch data;

  const ShipmentDispatch({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildTotalCard(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPendingCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildTransitCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
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

  Widget _buildPendingCard() {
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

  Widget _buildTransitCard() {
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
