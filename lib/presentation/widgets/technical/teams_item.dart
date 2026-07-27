import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/tech_material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class TeamsItem extends StatefulWidget {
  final String? selectedMaterial;
  final int? quantity;
  final List<TechMaterial> materials;


  final ValueChanged<String>? onMaterialChanged;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onDeleteMaterial;


  final VoidCallback? onRemove;

  const TeamsItem({
    super.key,
    this.selectedMaterial,
    this.quantity,
    this.onMaterialChanged,
    this.onQuantityChanged, 
    this.onRemove, 
    this.onDeleteMaterial,
    required this.materials,
  });

  @override
  State<TeamsItem> createState() => _TeamsItemState();
}

class _TeamsItemState extends State<TeamsItem> {
  late TextEditingController _qtyCtrl;
  late FocusNode _qtyFocus;

  late FocusNode _nameTeamFocus;
  late TextEditingController _nameTeamCtrl;

  String _materialValue = '0';
  

  @override
  void initState() {
    super.initState();
    _materialValue = widget.selectedMaterial ?? '0';

    _qtyCtrl = TextEditingController(text: widget.quantity?.toString() ?? '');
    _nameTeamCtrl = TextEditingController(text: widget.selectedMaterial?.toString() ?? '');

    _qtyFocus = FocusNode();
    _nameTeamFocus = FocusNode();
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _qtyFocus.dispose();
    
    _nameTeamCtrl.dispose();
    _nameTeamFocus.dispose();

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
              // const SizedBox(height: 12),
              // CustomFieldLabelRequired(txtLabel: 'Nombre'),
              Row(
                children: [
                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Nombre'),
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
                  fillColor: const Color.fromARGB(255, 25, 25, 30),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 75, 83, 83),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(190, 58, 199, 199),
                      width: 1.5,
                    ),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                    enabled: false,
                    value: '0',
                    child: Text(
                      'Seleccione una opción',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
        
                  ...widget.materials.map(
                      (c) => DropdownMenuItem(
                        value: c.idEquipment.toString(),
                        child: Text(
                          c.product,
                          style: TextStyle(color: Colors.white),
                        ),
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
