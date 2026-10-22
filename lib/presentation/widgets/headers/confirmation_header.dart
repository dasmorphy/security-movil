import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class ConfirmationHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const ConfirmationHeader({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.surfaceAlt,
                  border: Border.all(
                    color: context.colors.borderStrong,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: context.colors.icon,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
