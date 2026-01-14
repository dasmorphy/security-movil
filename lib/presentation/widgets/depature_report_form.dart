import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class DepatureReportForm extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onSubmit;
  const DepatureReportForm({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<DepatureReportForm> createState() => _DepatureReportFormState();
}

class _DepatureReportFormState extends State<DepatureReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _status = '0';
  final _guideCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _destinyCtrl = TextEditingController();
  final _authorizedCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();

  final FocusNode _guideFocus = FocusNode();
  final FocusNode _unitFocus = FocusNode();
  final FocusNode _providerFocus = FocusNode();
  final FocusNode _destinyFocus = FocusNode();
  final FocusNode _authorizedFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _statusFocus = FocusNode();

  @override
  void dispose() {
    _guideCtrl.dispose();
    _descCtrl.dispose();
    _quantityCtrl.dispose();
    _unitCtrl.dispose();
    _providerCtrl.dispose();
    _destinyCtrl.dispose();
    _authorizedCtrl.dispose();
    _observationsCtrl.dispose();
    _quantityFocus.dispose();
    _descFocus.dispose();
    _statusFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final data = {
      'status': _status,
      'title': _guideCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'quantity': int.tryParse(_quantityCtrl.text) ?? 0,
    };
    widget.onSubmit?.call(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulario enviado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      color: Colors.transparent,
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
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 280, // ajusta a tu diseño
                    child: Text(
                      'Registro Integral de Ingresos',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                fieldLabel('Categoría de ingreso'),
                GlowDropdownFormField<String>(
                  value: _status,
                  focusNode: _statusFocus,
                  decoration: styleDecoration(),
                  items: const [
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Seleccione una opción'),
                    ),
                    DropdownMenuItem(
                      value: 'MAT',
                      child: Text('Materiales - MAT'),
                    ),
                    DropdownMenuItem(
                      value: 'SUM',
                      child: Text('Suministros - SUM'),
                    ),
                    DropdownMenuItem(
                      value: 'REP',
                      child: Text('Repuestos - REP'),
                    ),
                    DropdownMenuItem(
                      value: 'BAL',
                      child: Text('Balanceado - BAL'),
                    ),
                    DropdownMenuItem(value: 'LAR', child: Text('Larvas - LAR')),
                    DropdownMenuItem(
                      value: 'MAQ',
                      child: Text('Maquinaria - MAQ'),
                    ),
                    DropdownMenuItem(
                      value: 'EQUI',
                      child: Text('Equipos - EQUI'),
                    ),
                    DropdownMenuItem(
                      value: 'COMB',
                      child: Text('Combustibles / Lubricantes'),
                    ),
                    DropdownMenuItem(value: 'OTS', child: Text('Otros')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _status = v);
                    }
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('OC/ Guia de remision'),
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

                fieldLabel('Descripción'),
                GlowTextFormField(
                  controller: _descCtrl,
                  focusNode: _descFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('Cantidad'),
                GlowTextFormField(
                  controller: _quantityCtrl,
                  focusNode: _quantityFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return messageValidatorEmpty;
                    final n = int.tryParse(v);
                    if (n == null) return 'Cantidad inválida';
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('Unidad'),
                GlowTextFormField(
                  controller: _unitCtrl,
                  focusNode: _unitFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('Proveedor / Origen'),
                GlowTextFormField(
                  controller: _providerCtrl,
                  focusNode: _providerFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('Destino Interno'),
                GlowTextFormField(
                  controller: _destinyCtrl,
                  focusNode: _destinyFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                fieldLabel('Autorizado por'),
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
                fieldLabel('Observaciones'),
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

                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _guideCtrl.clear();
                          _descCtrl.clear();
                          _quantityCtrl.clear();
                          _unitCtrl.clear();
                          _providerCtrl.clear();
                          _destinyCtrl.clear();
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

Widget fieldLabel(String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white)),
          const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
      const SizedBox(height: 6),
    ],
  );
}
