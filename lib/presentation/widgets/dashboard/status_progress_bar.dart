import 'package:flutter/material.dart';

class StatusProgressBar extends StatelessWidget {
  /// Etiqueta descriptiva del estado.
  final String label;

  /// Cantidad de registros en este estado.
  final int count;

  /// Total de registros (denominador para calcular el porcentaje).
  final int total;

  /// Color de la barra y el conteo. Por defecto usa el color primario del tema.
  final Color? color;

  /// Altura de la barra de progreso. Por defecto 6px.
  final double barHeight;

  /// Color de fondo de la barra (parte vacía). Por defecto gris claro.
  final Color? backgroundColor;

  const StatusProgressBar({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    this.color,
    this.barHeight = 6,
    this.backgroundColor,
  });

  double get _percentage => total == 0 ? 0 : (count / total).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedBg = backgroundColor ?? Colors.white.withOpacity(0.15);
    final pct = (_percentage * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // const SizedBox(width: 8),
            // Text(
            //   '$count',
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.w500,
            //     color: resolvedColor,
            //   ),
            // ),
            const SizedBox(width: 6),
            SizedBox(
              width: 32,
              child: Text(
                '$pct%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(barHeight),
          child: LinearProgressIndicator(
            value: _percentage,
            minHeight: barHeight,
            backgroundColor: resolvedBg,
            valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
          ),
        ),
      ],
    );
  }
}
