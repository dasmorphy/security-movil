import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class MultiSelectItem<T> {
  final T value;
  final String label;

  const MultiSelectItem({
    required this.value,
    required this.label,
  });
}

class GlowTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final int? maxLength;
  final ValueChanged<String?>? onChanged;
  final int maxLines;
  final bool enabled;
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
            enabled: enabled,
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
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
  final bool enabled;
  final FocusNode focusNode;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator; // ✅ AQUÍ
  final InputDecoration decoration;
  final Color glowColor;

  const GlowDropdownFormField({
    super.key,
    required this.value,
    required this.focusNode,
    required this.items,
    required this.onChanged,
    required this.decoration,
    this.enabled = true,
    this.glowColor = const Color.fromARGB(190, 58, 199, 199),
    this.validator,
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
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            dropdownColor: decoration.fillColor,
            decoration: decoration,
            items: items,
            validator: validator,
            onChanged: enabled ? onChanged : null,
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Text(
                  item.child is Text ? (item.child as Text).data ?? '' : '',
                  style: TextStyle(
                    color: enabled
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(255, 84, 81, 81),
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
  final Color glowColor;
  final Color textColor;
  final String searchHint;

  const GlowDropdownFormField2({
    super.key,
    required this.value,
    this.focusNode,
    required this.items,
    required this.onChanged,
    this.decoration,
    this.enabled = true,
    this.glowColor = const Color.fromARGB(190, 58, 199, 199),
    this.validator,
    this.textColor = Colors.white,
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
          color: widget.decoration?.fillColor,
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
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              prefixIcon: const Icon(Icons.search, color: Colors.white,),
              filled: true,
              fillColor: const Color.fromARGB(40, 255, 255, 255),
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
                color: widget.enabled
                    ? widget.textColor
                    : const Color.fromARGB(255, 84, 81, 81),
              ),
            ),
          );
        }).toList();
      },
    );
  }
}

class GlowMultiSelectFormField<T> extends StatelessWidget {
  final List<T> values;
  final List<MultiSelectItem<T>> items;
  final ValueChanged<List<T>> onChanged;
  final InputDecoration decoration;
  final bool enabled;
  final FocusNode? focusNode;
  final Color glowColor;
  final FormFieldValidator<List<T>>? validator;

  const GlowMultiSelectFormField({
    super.key,
    required this.values,
    required this.items,
    required this.onChanged,
    required this.decoration,
    this.enabled = true,
    this.focusNode,
    this.validator,
    this.glowColor = const Color.fromARGB(190, 58, 199, 199),
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: values,
      validator: validator,
      builder: (field) {
        return GestureDetector(
          onTap: enabled
              ? () async {
                  final result = await showDialog<List<T>>(
                    context: context,
                    builder: (_) => MultiSelectDialog<T>(
                      values: List.from(field.value ?? []),
                      items: items,
                    ),
                  );

                  if (result != null) {
                    field.didChange(result);
                    onChanged(result);
                  }
                }
              : null,
          child: InputDecorator(
            decoration: decoration.copyWith(
              errorText: field.errorText,
            ),
            child: Wrap(
              spacing: 6,
              children: (field.value ?? []).map((e) {
                final item = items.firstWhere((i) => i.value == e);

                return Chip(
                  label: Text(item.label),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}