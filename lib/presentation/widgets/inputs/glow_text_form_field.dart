import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/config/utils/helper.dart';

class GlowTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final int? maxLength;
  final ValueChanged<String?>? onChanged;
  final int maxLines;
  final bool enabled;
  final bool uppercase;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const GlowTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hint,
    this.maxLength,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.uppercase = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
                      color: colors.focus.withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(color: colors.textPrimary),
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: [
              if (uppercase) UpperCaseTextFormatter(),
              ...?inputFormatters,
            ],
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.fieldFill,
              hintText: hint,
              hintStyle: TextStyle(color: colors.textTertiary),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: colors.focus, width: 1.5),
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
  final bool enabled;
  final FocusNode focusNode;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator; // ✅ AQUÍ
  final InputDecoration decoration;
  final Color? glowColor;

  const GlowDropdownFormField({
    super.key,
    required this.value,
    required this.focusNode,
    required this.items,
    required this.onChanged,
    required this.decoration,
    this.enabled = true,
    this.glowColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final glow = glowColor ?? colors.focus;

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
                      color: glow.withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            focusNode: focusNode,
            style: TextStyle(color: colors.textPrimary),
            dropdownColor: decoration.fillColor ?? colors.fieldFill,
            decoration: decoration,
            items: items,
            validator: validator,
            onChanged: enabled ? onChanged : null,
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Text(
                  item.child is Text ? (item.child as Text).data ?? '' : '',
                  style: TextStyle(
                    color: enabled ? colors.textPrimary : colors.textTertiary,
                  ),
                );
              }).toList();
            },
          ),
        );
      },
    );
  }
}

class GlowDropdownFormField2<T> extends StatefulWidget {
  final T? value;
  final bool enabled;
  final FocusNode? focusNode;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final InputDecoration? decoration;
  final Color? glowColor;
  final Color? textColor;
  final String searchHint;

  const GlowDropdownFormField2({
    super.key,
    required this.value,
    this.focusNode,
    required this.items,
    required this.onChanged,
    this.decoration,
    this.enabled = true,
    this.glowColor,
    this.validator,
    this.textColor,
    this.searchHint = 'Buscar...',
  });

  @override
  State<GlowDropdownFormField2<T>> createState() =>
      _GlowDropdownFormField2State<T>();
}

class _GlowDropdownFormField2State<T> extends State<GlowDropdownFormField2<T>> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = widget.textColor ?? colors.textPrimary;

    return DropdownButtonFormField2<T>(
      value: widget.value,
      focusNode: widget.focusNode,
      isExpanded: true,
      decoration: widget.decoration,
      items: widget.items,
      validator: widget.validator,
      onChanged: widget.enabled ? widget.onChanged : null,

      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: widget.decoration?.fillColor ?? colors.fieldFill,
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      menuItemStyleData: const MenuItemStyleData(height: 48),

      // 🔍 SEARCH
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidgetHeight: 8,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(2),
          child: TextFormField(
            controller: searchController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: TextStyle(color: colors.textTertiary),
              prefixIcon: Icon(Icons.search, color: colors.icon),
              filled: true,
              fillColor: colors.textPrimary.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        searchMatchFn: (item, searchValue) {
          final text = item.child is Text
              ? (item.child as Text).data ?? ''
              : '';

          return text.toLowerCase().contains(searchValue.toLowerCase());
        },
      ),

      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          searchController.clear();
        }
      },

      selectedItemBuilder: (context) {
        return widget.items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.child is Text ? (item.child as Text).data ?? '' : '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.enabled ? textColor : colors.textTertiary,
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
