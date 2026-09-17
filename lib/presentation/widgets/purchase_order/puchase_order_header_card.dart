import 'package:flutter/material.dart';

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
        color: const Color.fromARGB(255, 30, 30, 35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 75, 83, 83),
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
                  const Text(
                    'Número de orden',
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    purchaseOrder.numberOrder,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 76, 195, 233),
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
              color: const Color.fromARGB(255, 150, 150, 150),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 150, 150, 150),
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
