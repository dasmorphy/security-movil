import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

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
            Text(txtLabel, style: TextStyle(color: context.colors.textPrimary)),

            if (isRequired)
              Text(' *', style: TextStyle(color: context.colors.error)),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
