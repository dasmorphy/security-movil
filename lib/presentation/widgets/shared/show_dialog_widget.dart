import 'package:flutter/material.dart';

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
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A2A),
      title: title != null
          ? Text(title!, style: const TextStyle(color: Colors.white))
          : null,
      content: content != null
          ? Text(content!, style: const TextStyle(color: Colors.white70))
          : null,
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
