import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';

class CommentaryReception extends StatelessWidget {
  final String label;
  final String hint;
  final bool showLabel;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;

  const CommentaryReception({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.showLabel = true,
    this.label = 'COMENTARIO/NOVEDAD',
    this.hint = '',
    this.minLines = 3,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final fieldFill = context.isDarkMode
        ? const Color.fromARGB(255, 25, 25, 30)
        : context.colors.fieldFill;
    final borderRadius = BorderRadius.circular(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)...[
          Text(
            label,
            style: TextStyle(
              color: context.colors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: focusNode,
          builder: (_, __) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: focusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: context.colors.focus.withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: TextStyle(color: context.colors.textPrimary),
                minLines: minLines,
                maxLines: maxLines,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldFill,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: context.isDarkMode
                        ? const Color.fromARGB(255, 100, 100, 100)
                        : context.colors.textTertiary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: context.colors.borderStrong,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: context.colors.focus,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
