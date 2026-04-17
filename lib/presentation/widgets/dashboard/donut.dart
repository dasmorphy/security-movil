import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/graph_dispatch.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class DiscrepancyDonutWidget extends StatelessWidget {
  final GraphDispatch data;

  const DiscrepancyDonutWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pct = data.discrepancyPercentage;

    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      elevation: 0,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(16),
      //   side: BorderSide(color: Colors.grey.shade200),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Dona centrada
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _DonutPainter(
                      percentage: pct / 100,
                      discrepancyColor: const Color(0xFFE24B4A),
                      okColor: const Color(0xFF1D9E75),
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 14,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${pct.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'discrepancias',
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Leyenda
          _LegendItem(
            color: const Color(0xFFE24B4A),
            label: 'Con discrepancia',
            count: data.discrepancy,
            percentage: pct,
          ),
          const SizedBox(height: 10),
          _LegendItem(
            color: const Color(0xFF1D9E75),
            label: 'Sin discrepancia',
            count: data.okRecords,
            percentage: 100 - pct,
          ),

          const Divider(height: 28, thickness: 0.5),

          // Estados de despacho
          ...data.dispatchByStatus.map(
            (s) => Padding(
              // padding: const EdgeInsets.symmetric(vertical: 4),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       s.statusName,
              //       style: TextStyle(fontSize: 12, color: Colors.white),
              //     ),
              //     Text(
              //       '${s.count}',
              //       style: const TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: StatusProgressBar(
                label: s.statusName,
                count: s.count,
                total: data.totalRecords,
                color: const Color(0xFF1D9E75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Item de leyenda ---
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final double percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// --- CustomPainter de la dona ---
class _DonutPainter extends CustomPainter {
  final double percentage; // 0.0 - 1.0
  final Color discrepancyColor;
  final Color okColor;
  final Color backgroundColor;
  final double strokeWidth;

  const _DonutPainter({
    required this.percentage,
    required this.discrepancyColor,
    required this.okColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Fondo completo
    canvas.drawCircle(center, radius, basePaint);

    const startAngle = -pi / 2; // Inicio arriba

    // Arco discrepancias (rojo)
    if (percentage > 0) {
      final discPaint = Paint()
        ..color = discrepancyColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, 2 * pi * percentage, false, discPaint);
    }

    // Arco sin discrepancia (verde)
    final okPercentage = 1 - percentage;
    if (okPercentage > 0) {
      final okPaint = Paint()
        ..color = okColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle + (2 * pi * percentage),
        2 * pi * okPercentage,
        false,
        okPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.percentage != percentage;
}
