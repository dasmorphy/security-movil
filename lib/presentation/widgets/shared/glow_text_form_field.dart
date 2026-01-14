import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlowTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const GlowTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final fieldFill = const Color.fromARGB(255, 20, 21, 23);
    final borderRadius = BorderRadius.circular(8);

    return AnimatedBuilder(
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
                      ).withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldFill,
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: Colors.white12),
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
    );
  }
}

class GlowDropdownFormField<T> extends StatelessWidget {
  final T value;
  final FocusNode focusNode;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final InputDecoration decoration;
  final Color glowColor;

  const GlowDropdownFormField({
    super.key,
    required this.value,
    required this.focusNode,
    required this.items,
    required this.onChanged,
    required this.decoration,
    this.glowColor = const Color.fromARGB(190, 58, 199, 199),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (_, __) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: glowColor.withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            focusNode: focusNode,
            dropdownColor: decoration.fillColor,
            style: const TextStyle(color: Colors.white),
            decoration: decoration,
            items: items,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}
