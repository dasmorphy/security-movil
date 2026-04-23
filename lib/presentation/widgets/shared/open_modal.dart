import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ModalHelper {
  static Future<T?> open<T>(
    BuildContext context, {
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return AnimatedModal(child: child);
      },
    );
  }
}