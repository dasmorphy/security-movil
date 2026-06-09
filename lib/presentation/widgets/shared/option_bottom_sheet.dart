import 'package:flutter/material.dart';

class BottomSheetOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  BottomSheetOption({required this.value, required this.label, this.icon});
}

class OptionBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<BottomSheetOption<T>> options,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...options.map(
                  (option) => ListTile(
                    leading: option.icon != null ? Icon(option.icon) : null,
                    title: Text(option.label),
                    onTap: () {
                      Navigator.pop(context, option.value);
                    },
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
