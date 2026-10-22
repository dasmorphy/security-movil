import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: colors.sheet,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: colors.textTertiary),
          prefixIcon: Icon(Icons.search, color: colors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}