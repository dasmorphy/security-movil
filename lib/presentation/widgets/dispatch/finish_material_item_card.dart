import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class FinishMaterialItemCard extends StatelessWidget {
  final String materialName;
  final int quantity;
  final bool? isChecked;
  final ValueChanged<bool>? onChanged;

  const FinishMaterialItemCard({
    super.key,
    required this.materialName,
    required this.quantity,
    this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materialName,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cantidad: $quantity unidad(es)',
                      style: TextStyle(
                        color: context.colors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isChecked != null && onChanged != null) _buildToggle(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged!(!isChecked!),
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isChecked!
              ? context.colors.success
              : context.colors.borderStrong,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isChecked! ? 24 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
