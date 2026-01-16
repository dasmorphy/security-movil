import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class BasicServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Widget childWidget;

  const BasicServiceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.childWidget,
    this.backgroundColor = const Color(0xFF2a2a2a),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openModal(context),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return AnimatedModal(child: childWidget);
      },
    );
  }
}
