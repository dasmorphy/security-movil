import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
      onTap: () => _openModal(context, null),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color.fromARGB(120, 46, 175, 132), width: 1),
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
              color: const Color.fromARGB(255, 46, 175, 132).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 25, color: const Color.fromARGB(255, 50, 182, 182)),
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

  void _openModal(BuildContext context, double? height) {
    final double heightModal =
      height ?? MediaQuery.of(context).size.height * 0.89;
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E1E1E),
      duration: Duration(milliseconds: 600),
      expand: false,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: SizedBox(
          height: heightModal,
          child: childWidget
        ),
      ),
    );
  }
}
