import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:path/path.dart';

class BottomSheetOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  BottomSheetOption({required this.value, required this.label, this.icon});
}

class OptionBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required List<BottomSheetOption<T>> options,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: context.colors.card,
      useRootNavigator: true,
      builder: (sheetContext) {
        final colors = sheetContext.colors;

        return SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),

                if (title != null)...[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ...options.map(
                  (option) => ListTile(
                    leading: option.icon != null ? Icon(option.icon, color: colors.icon) : null,
                    title: Text(option.label, style: TextStyle(color: colors.textPrimary)),
                    onTap: () {
                      Navigator.pop(context, option.value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
        );
      },
    );
  }
}
