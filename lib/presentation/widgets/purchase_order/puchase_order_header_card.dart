import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class HeaderInfoPurchaseOrder {
  final int purchaseOrderId;
  final String typeOrder;
  // final String destinyName;
  final String numberOrder;

  const HeaderInfoPurchaseOrder({
    required this.purchaseOrderId,
    required this.typeOrder,
    // required this.destinyName,
    required this.numberOrder,
  });
}

class PuchaseOrderHeaderCard extends StatelessWidget {
  final HeaderInfoPurchaseOrder purchaseOrder;


  const PuchaseOrderHeaderCard({
    super.key,
    required this.purchaseOrder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.borderStrong,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Número de orden',
                    style: TextStyle(
                      color: context.colors.textTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    purchaseOrder.numberOrder,
                    style: TextStyle(
                      color: context.colors.highlight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoColumn(
                  label: 'TIPO',
                  value: purchaseOrder.typeOrder,
                  icon: Icons.location_on,
                ),
              ),
              const SizedBox(width: 16),
              // Expanded(
              //   child: _InfoColumn(
              //     label: 'DESTINO',
              //     value: purchaseOrder.destinyName,
              //     icon: Icons.person,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: context.colors.textTertiary,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: context.colors.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
