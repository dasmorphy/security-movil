import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class ShowDialogWidget extends StatelessWidget {
  final String? title;
  final String? content;
  final String buttonText;
  final VoidCallback? onPressed;

  const ShowDialogWidget({
    super.key,
    this.title,
    this.content,
    this.buttonText = "OK",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.overlayPanel,
      title: title != null
          ? Text(title!, style: TextStyle(color: colors.textPrimary))
          : null,
      content: content != null
          ? Text(content!, style: TextStyle(color: colors.textSecondary))
          : null,
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text(
            buttonText,
            style: TextStyle(
              color: context.isDarkMode ? Colors.greenAccent : colors.success,
            ),
          ),
        ),
      ],
    );
  }
}
