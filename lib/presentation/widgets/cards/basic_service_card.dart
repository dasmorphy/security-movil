import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/modals/animated_modal.dart';

class BasicServiceCard extends StatelessWidget {
  final String iconImage;
  final String label;
  final Color backgroundColor;
  final Widget? childWidget;
  final VoidCallback? onTap;
  
  const BasicServiceCard({
    super.key,
    required this.iconImage,
    required this.label,
    this.childWidget,
    this.backgroundColor = const Color(0xFF2a2a2a), 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(); // 👉 descarga u otra acción
        } else if (childWidget != null) {
          _openModal(context); // 👉 abre modal
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color.fromARGB(255, 75, 83, 83), width: 1),
          // border: Border(
          //   top: BorderSide(
          //     color: Color.fromARGB(171, 46, 175, 132),
          //   ),
          //   right: BorderSide(
          //     color: const Color.fromARGB(127, 57, 124, 110),
          //   ),
          //   bottom: BorderSide(
          //     color: const Color.fromARGB(255, 34, 60, 82),
          //   ),
          //   left: BorderSide(
          //     color: const Color.fromARGB(255, 37, 52, 65),
          //   ),
          // ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 48, 49, 49).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(icon, size: 25, color: const Color.fromARGB(255, 50, 182, 182)),
              Image.asset(
                'assets/images/icons/$iconImage.png',
                width: 30,
                height: 30,
                // fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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
        return AnimatedModal(child: childWidget ?? const Placeholder());
      },
    );
  }
}
