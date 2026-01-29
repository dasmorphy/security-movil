import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ExitReportForm extends ConsumerStatefulWidget {
  final Future<bool> Function(Map<String, dynamic>)? onSubmit;
  const ExitReportForm({super.key, this.onSubmit});

  @override
  ConsumerState<ExitReportForm> createState() => _ExitReportFormState();
}

class _ExitReportFormState extends ConsumerState<ExitReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _categoryEntry = '0';
  final _guideCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _truckLicenseCtrl = TextEditingController();
  final _nameDriverCtrl = TextEditingController();
  final _authorizedCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _personWithdrawsCtrl = TextEditingController();
  int? _unityId;

  final FocusNode _guideFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();
  final FocusNode _truckLicenseFocus = FocusNode();
  final FocusNode _nameDriverFocus = FocusNode();
  final FocusNode _authorizedFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _categoryEntryFocus = FocusNode();
  final FocusNode _personWithdrawsFocus = FocusNode();
  final FocusNode _unitFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    ref.read(getAllCategories.notifier).load();
  }
  
  @override
  void dispose() {
    _guideCtrl.dispose();
    _quantityCtrl.dispose();
    _truckLicenseCtrl.dispose();
    _nameDriverCtrl.dispose();
    _authorizedCtrl.dispose();
    _observationsCtrl.dispose();
    _quantityFocus.dispose();
    _descFocus.dispose();
    _categoryEntryFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_unityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar una categoría válida')),
      );
      return;
    }

    final data = {
      "id_unity": _unityId,
      "id_category": int.parse(_categoryEntry), //
      "shipping_guide": _guideCtrl.text.trim(),
      "name_driver": _nameDriverCtrl.text.trim(),
      "quantity": int.tryParse(_quantityCtrl.text) ?? 0,
      "weight": int.tryParse(_weightCtrl.text) ?? 0,
      "truck_license": _truckLicenseCtrl.text.trim(), //
      "person_withdraws": _personWithdrawsCtrl.text.trim(), //
      "destiny": _nameDriverCtrl.text.trim(), //
      "authorized_by": _authorizedCtrl.text.trim(), //
      "observations": _observationsCtrl.text.trim(), 
      "created_by": "dmales", //
      "id_group_business": 1,
    };
    final success = await widget.onSubmit?.call(data) ?? false;
    
    if (success) {
      if (mounted) {
        context.go('/check-success');
      }
    } else {
        if (mounted) {
          context.pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(getAllCategories);
    final unitiesWeight = ref.watch(getAllUnitiesWeight);
    final messageValidatorEmpty = 'Este campo es obligatorio';
    final fieldFill = const Color.fromARGB(255, 20, 21, 23);
    final borderRadius = BorderRadius.circular(8.0);

    InputDecoration styleDecoration() => InputDecoration(
      filled: true,
      fillColor: fieldFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Color.fromARGB(190, 58, 199, 199)),
      ),
    );

    return Card(
      color: const Color.fromARGB(0, 150, 60, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 280, // ajusta a tu diseño
                    child: Text(
                      'Registro Integral de Salida',
                      textAlign: TextAlign.left,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 280, // ajusta a tu diseño
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        // vertical: 6,
                        // horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red,),
                          const Text(
                            'Camanglar 3',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                CustomFieldLabelRequired(txtLabel: 'Categoría de ingreso'),
                GlowDropdownFormField<String>(
                  value: _categoryEntry,
                  focusNode: _categoryEntryFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Seleccione una opción'),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(
                        value: c.idCategory.toString(),
                        child: Text(c.nameCategory),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _categoryEntry = v);
                      _unityId = getUnityIdByCategory(
                        nameCategory: categories.firstWhere(
                          (u) => u.idCategory== int.parse(v),
                          orElse: () => throw Exception('Categoría no encontrada'),
                        ).nameCategory,
                        unities: unitiesWeight,
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Guía / Documento'),
                GlowTextFormField(
                  controller: _guideCtrl,
                  focusNode: _guideFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Cantidad de Bines'),
                GlowTextFormField(
                  controller: _quantityCtrl,
                  focusNode: _quantityFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return messageValidatorEmpty;
                    final n = int.tryParse(v);
                    if (n == null) return 'Cantidad inválida';
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Unidad'),
                GlowDropdownFormField<String>(
                  enabled: false,
                  value: _unityId?.toString() ?? '0',
                  focusNode: _unitFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text('Seleccione una opción'),
                    ),
                    ...unitiesWeight.map(
                      (c) => DropdownMenuItem(
                        value: c.idUnity.toString(),
                        child: Text('${c.name} - ${c.code}'),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    // if (v != null) {
                    //   setState(() => _unit = v);
                    // }
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Peso'),
                GlowTextFormField(
                  controller: _weightCtrl,
                  focusNode: _weightFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return messageValidatorEmpty;
                    final n = int.tryParse(v);
                    if (n == null) return 'Cantidad inválida';
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Placa del Camión'),
                GlowTextFormField(
                  controller: _truckLicenseCtrl,
                  focusNode: _truckLicenseFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Nombre del Chofer'),
                GlowTextFormField(
                  controller: _nameDriverCtrl,
                  focusNode: _nameDriverFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Custodia que Retira el Producto'),
                GlowTextFormField(
                  controller: _personWithdrawsCtrl,
                  focusNode: _personWithdrawsFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(
                  txtLabel: 'Destino',
                ),
                GlowTextFormField(
                  controller: _observationsCtrl,
                  focusNode: _observationsFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(
                  txtLabel: 'Autorizado por',
                ),
                GlowTextFormField(
                  controller: _authorizedCtrl,
                  focusNode: _authorizedFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(
                  txtLabel: 'Observaciones',
                  isRequired: false,
                ),
                GlowTextFormField(
                  controller: _observationsCtrl,
                  focusNode: _observationsFocus,
                  validator: (v) {
                    return null;
                  },
                ),

                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _categoryEntry = '0';
                          _guideCtrl.clear();
                          _nameDriverCtrl.clear();
                          _quantityCtrl.clear();
                          _weightCtrl.clear();
                          _truckLicenseCtrl.clear();
                          _nameDriverCtrl.clear();
                          _authorizedCtrl.clear();
                          _observationsCtrl.clear();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
