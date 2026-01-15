import 'package:flutter/material.dart';

class CustomFieldLabelRequired extends StatelessWidget {
  final String txtLabel;
  final bool isRequired;

  const CustomFieldLabelRequired({
    super.key,
    required this.txtLabel,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(txtLabel, style: const TextStyle(color: Colors.white)),

            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
