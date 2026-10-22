import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class ShipmentDispatch extends ConsumerWidget {
  const ShipmentDispatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(graphDispatchProvider);

    if (data == null) {
      return Text(
        'No hay registros',
        style: TextStyle(color: context.colors.textPrimary.withOpacity(0.54)),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildTotalCard(context, data),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPendingCard(context, data)),
              const SizedBox(width: 12),
              Expanded(child: _buildTransitCard(context, data)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context, GraphDispatch data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context, null),
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
                style: TextStyle(
                  color: context.colors.textPrimary,
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

  Widget _buildPendingCard(BuildContext context, GraphDispatch data) {
    return Container(
      // height: 115,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context, Colors.orange),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ingresado bodega",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            data.getCountByStatus('Ingresado en bodega').toString(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildTransitCard(BuildContext context, GraphDispatch data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context, Color.fromARGB(255, 11, 126, 202)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Salida de planta",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            data.getCountByStatus('Salida de planta').toString(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context, Color? colorBorder) {
    return BoxDecoration(
      color: (context.isDarkMode ? const Color(0xFF1C1C1E) : context.colors.card),
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
