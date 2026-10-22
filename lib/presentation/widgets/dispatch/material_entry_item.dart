import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class MaterialEntryItem extends StatefulWidget {
  final dynamic materials;
  final String? selectedMaterial;
  final int? quantity;
  final String? otherMaterial;

  final ValueChanged<String>? onMaterialChanged;
  final ValueChanged<int>? onQuantityChanged;
  final ValueChanged<String>? onOtherMaterialChanged;
  final VoidCallback? onDeleteMaterial;


  final VoidCallback? onRemove;

  const MaterialEntryItem({
    super.key,
    required this.materials,
    this.selectedMaterial,
    this.quantity,
    this.otherMaterial,
    this.onMaterialChanged,
    this.onQuantityChanged, 
    this.onOtherMaterialChanged, 
    this.onRemove, 
    this.onDeleteMaterial,
  });

  @override
  State<MaterialEntryItem> createState() => _MaterialEntryItemState();
}

class _MaterialEntryItemState extends State<MaterialEntryItem> {
  late TextEditingController _qtyCtrl;
  late FocusNode _qtyFocus;

  late TextEditingController _otherCtrl;
  late FocusNode _otherFocus;


  String _materialValue = '0';

  @override
  void initState() {
    super.initState();

    _materialValue = widget.selectedMaterial ?? '0';

    _qtyCtrl = TextEditingController(text: widget.quantity?.toString() ?? '');
    _otherCtrl = TextEditingController(text: widget.otherMaterial?.toString() ?? '');

    _qtyFocus = FocusNode();
    _otherFocus = FocusNode();
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _qtyFocus.dispose();

    _otherCtrl.dispose();
    _otherFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final materials = ref.watch(materialsProvider);

    return Column(
      children: [
        const SizedBox(height: 12,),

        Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          padding: const EdgeInsets.all(16),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [          
              Row(
                children: [
                  Text(
                    'MATERIAL',
                    style: TextStyle(
                      color: context.colors.textTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onDeleteMaterial != null)
                    GestureDetector(
                      onTap: widget.onRemove,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: kTextHint,
                      ),
                    ),
                ],
              ),
        
              const SizedBox(height: 12),
        
              GlowDropdownFormField2<String>(
                value: _materialValue,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.isDarkMode
                      ? const Color.fromARGB(255, 25, 25, 30)
                      : context.colors.fieldFill,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.colors.borderStrong,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.colors.focus,
                      width: 1.5,
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    enabled: false,
                    value: '0',
                    child: Text(
                      'Seleccione una opción',
                      style: TextStyle(color: context.colors.textPrimary),
                    ),
                  ),
        
                  ...widget.materials.map(
                    (c) => DropdownMenuItem(
                      value: c['id_material'].toString(),
                      child: Text(
                        c['name'],
                        style: TextStyle(color: context.colors.textPrimary),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '1000',
                    child: Text(
                      'Otros',
                      style: TextStyle(color: context.colors.textPrimary),
                    ),
                  ),
                ],
        
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _materialValue = v);
        
                    widget.onMaterialChanged?.call(v);
                  }
                },
        
                validator: (v) {
                  if (v == '0' || v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),
        
              const SizedBox(height: 16),
              
              Text(
                'CANTIDAD',
                style: TextStyle(
                  color: context.colors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              GlowTextFormField(
                controller: _qtyCtrl,
                focusNode: _qtyFocus,
                hint: 'Ingrese la cantidad',
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  if (v != null) {
                    widget.onQuantityChanged?.call(
                      int.tryParse(v) ?? 0,
                    );
                  }
                },
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              
              if (_materialValue == '1000')...[
                Text(
                  'OTRO',
                  style: TextStyle(
                    color: context.colors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                GlowTextFormField(
                  controller: _otherCtrl,
                  focusNode: _otherFocus,
                  onChanged: (v) {
                    if (v != null) {
                      widget.onOtherMaterialChanged?.call(v);
                    }
                  },
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 12,)
            ],
          ),
        ),

      ],
    );
  }
}
