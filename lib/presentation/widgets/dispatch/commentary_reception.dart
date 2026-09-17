import 'package:flutter/material.dart';

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
    const fieldFill = Color.fromARGB(255, 25, 25, 30);
    final borderRadius = BorderRadius.circular(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)...[
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 150, 150, 150),
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
                          color: const Color.fromARGB(
                            190,
                            58,
                            199,
                            199,
                          ).withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                minLines: minLines,
                maxLines: maxLines,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldFill,
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 75, 83, 83),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: const BorderSide(
                      color: Color.fromARGB(190, 58, 199, 199),
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
