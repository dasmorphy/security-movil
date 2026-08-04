import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class MultiSelectDialog<T> extends StatefulWidget {
  final List<T> values;
  final List<MultiSelectItem<T>> items;

  const MultiSelectDialog({
    super.key,
    required this.values,
    required this.items,
  });

  @override
  State<MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  late List<T> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.values);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text("Seleccionar", style: TextStyle(color: Colors.white, fontSize: 17),),
      content: SizedBox(
        width: double.maxFinite,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
          ),
          child: ListView(
            shrinkWrap: true,
            children: widget.items.map((item) {
              return CheckboxListTile(
                value: selected.contains(item.value),
                title: Text(item.label, style: const TextStyle(color: Colors.white)),
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      selected.add(item.value);
                    } else {
                      selected.remove(item.value);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color.fromARGB(
              189,
              7,
              213,
              213,
            ),
            disabledBackgroundColor: const Color.fromARGB(
              120,
              7,
              213,
              213,
            ),
          ),
          onPressed: () => Navigator.pop(context, selected),
          child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
