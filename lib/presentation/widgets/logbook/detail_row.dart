import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

Widget detailRow(String label, dynamic value) {
  // Builder para leer los colores del tema sin cambiar la firma (se usa en
  // muchos lugares).
  return Builder(builder: (context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value?.toString() ?? '—',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  ));
}