import 'package:flutter/material.dart';
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
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      useRootNavigator: true,
      builder: (_) {
        return SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),

                if (title != null)...[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ...options.map(
                  (option) => ListTile(
                    leading: option.icon != null ? Icon(option.icon, color: Colors.white) : null,
                    title: Text(option.label, style: TextStyle(color: Colors.white),),
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
