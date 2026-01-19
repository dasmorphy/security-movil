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
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
