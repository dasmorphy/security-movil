import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class DonutTechnical extends ConsumerWidget {
  const DonutTechnical({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(graphTechnicalProvider);

    if (data == null) {
      return const Text(
        'No hay registros',
        style: TextStyle(color: Colors.white54),
      );
    }

    final auditing = data.auditingPercentaje;
    final audited = auditing?.audited ?? 0;
    final notAudited = auditing?.notAudited ?? 0;
    final total = audited + notAudited;
    final auditedPercentage = total == 0 ? 0.0 : (audited / total) * 100;
    final notAuditedPercentage = total == 0 ? 0.0 : (notAudited / total) * 100;

    return Card(
      color: const Color.fromARGB(255, 11, 16, 20),
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
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _DonutPainter(
                      auditedPercentage: auditedPercentage / 100,
                      notAuditedPercentage: notAuditedPercentage / 100,
                      auditedColor: const Color(0xFF1D9E75),
                      notAuditedColor: const Color(0xFFE24B4A),
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 14,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${auditedPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'auditado',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
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
            color: const Color(0xFF1D9E75),
            label: 'Auditado',
            count: audited,
            percentage: auditedPercentage,
          ),
          const SizedBox(height: 10),
          _LegendItem(
            color: const Color(0xFFE24B4A),
            label: 'No auditado',
            count: notAudited,
            percentage: notAuditedPercentage,
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
  final double auditedPercentage; // 0.0 - 1.0
  final double notAuditedPercentage; // 0.0 - 1.0
  final Color auditedColor;
  final Color notAuditedColor;
  final Color backgroundColor;
  final double strokeWidth;

  const _DonutPainter({
    required this.auditedPercentage,
    required this.notAuditedPercentage,
    required this.auditedColor,
    required this.notAuditedColor,
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

    // Arco auditado (verde)
    if (auditedPercentage > 0) {
      final auditedPaint = Paint()
        ..color = auditedColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle,
        2 * pi * auditedPercentage,
        false,
        auditedPaint,
      );
    }

    // Arco no auditado (rojo)
    if (notAuditedPercentage > 0) {
      final notAuditedPaint = Paint()
        ..color = notAuditedColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle + (2 * pi * auditedPercentage),
        2 * pi * notAuditedPercentage,
        false,
        notAuditedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.auditedPercentage != auditedPercentage ||
      old.notAuditedPercentage != notAuditedPercentage;
}
