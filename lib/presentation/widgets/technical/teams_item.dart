import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class TeamsItem extends StatefulWidget {
  final String? selectedMaterial;
  final int? quantity;
  final String? otherMaterial;

  final ValueChanged<String>? onMaterialChanged;
  final ValueChanged<int>? onQuantityChanged;
  final ValueChanged<String>? onOtherMaterialChanged;
  final VoidCallback? onDeleteMaterial;


  final VoidCallback? onRemove;

  const TeamsItem({
    super.key,
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
  State<TeamsItem> createState() => _TeamsItemState();
}

class _TeamsItemState extends State<TeamsItem> {
  late TextEditingController _qtyCtrl;
  late FocusNode _qtyFocus;

  late TextEditingController _otherCtrl;
  late FocusNode _otherFocus;

  final FocusNode _nameTeamFocus = FocusNode();
  final _nameTeamCtrl = TextEditingController();
  

  @override
  void initState() {
    super.initState();

    final _materialValue = widget.selectedMaterial ?? '';

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
            color: const Color.fromARGB(255, 30, 30, 35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          padding: const EdgeInsets.all(16),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomFieldLabelRequired(txtLabel: 'Nombre'),
              GlowTextFormField(
                controller: _nameTeamCtrl,
                focusNode: _nameTeamFocus,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),
        
              const SizedBox(height: 16),
              
              const Text(
                'CANTIDAD',
                style: TextStyle(
                  color: Color.fromARGB(255, 150, 150, 150),
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

              const SizedBox(height: 12,)
            ],
          ),
        ),

      ],
    );
  }
}
