import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/service/pending_request_service.dart';

class BiomarEntryReportForm extends ConsumerStatefulWidget {
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;
  const BiomarEntryReportForm({super.key, required this.onSubmit});

  @override
  ConsumerState<BiomarEntryReportForm> createState() => _BiomarEntryReportFormState();
}

class _BiomarEntryReportFormState extends ConsumerState<BiomarEntryReportForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool imagesMinError = false;
  bool imagesMaxError = false;

  String _areaVisit = '0';
  String _typeAccess = '0';
  String _personCharge = '0';

  final _dniCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _nameVisitCtrl = TextEditingController();
  final _reasonVisitCtrl = TextEditingController();

  List<Uint8List?> _selectedImages = [];

  final FocusNode _truckLicenseFocus = FocusNode();
  final FocusNode _reasonVisitFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _dniFocus = FocusNode();
  final FocusNode _materialEntryFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _personChargeFocus = FocusNode();
  final FocusNode _areaVisitFocus = FocusNode();
  final FocusNode _typeAccessFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    ref.read(getMaterials.notifier).load();
    ref.read(getAreasVisit.notifier).load();
    ref.read(getStaffCharge.notifier).load();

  }

  @override
  void dispose() {
    _clearCntrl();
    super.dispose();
  }

  void _clearCntrl() {
    _selectedImages = [];
    _formKey.currentState?.reset();
    _dniFocus.dispose();
    _quantityCtrl.dispose();
    _providerCtrl.dispose();
    _reasonVisitCtrl.dispose();
    _nameVisitCtrl.dispose();
    _observationsCtrl.dispose();
    _quantityFocus.dispose();
    _personChargeFocus.dispose();
    _materialEntryFocus.dispose();
    _truckLicenseFocus.dispose();
    _reasonVisitFocus.dispose();
    imagesMinError = false;
    imagesMaxError = false;
  }

  void _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }

    if (_selectedImages.length < 5) {
      setState(() {
        imagesMinError = true;
        isLoading = false;
      });
      return;
    }

    if (_selectedImages.length > 10) {
      setState(() {
        imagesMaxError = true;
        isLoading = false;
      });
      return;
    }

    final authState = ref.watch(userSessionProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    final userData = authState.value!;

    // Construir los datos del formulario
    final data = {
      "external_transaction_id": Uuid().v4(),
      "area_visit": int.parse(_areaVisit),
      "dni": _dniCtrl.text.trim(),
      "quantity": int.tryParse(_quantityCtrl.text) ?? 0,
      "names_visit": _nameVisitCtrl.text.trim(),
      "observations": _observationsCtrl.text.trim(),
      "person_charge": int.parse(_personCharge),
      "reason_visit": _reasonVisitCtrl.text.trim(),
      "type_access": _typeAccess,
      "user": userData.user,
      "material_entry": materialsAdded.map((p) => {
        "id_material": int.parse(p['id_material']),
        "quantity": p['quantity'],
      }).toList(),
      "images": _selectedImages
        .whereType<Uint8List>()
        .toList(), // Lista de Uint8List directo, sin base64
    };

    // Verificar conexión a internet
    final internetAvailable = await hasInternet();

    if (!internetAvailable) {
      // 🔴 SIN INTERNET: Guardar localmente
      print('❌ Sin conexión, guardando localmente...');
      data['created_at'] = DateTime.now().toString();
      await savePendingBiomar(data, 'entry');

      if (mounted) {
        _clearCntrl();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 6),
            content: Text(
              '📱 Sin conexión. Tu información se guardará localmente y se enviará automáticamente cuando recuperes conexión.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 255, 152, 0),
          ),
        );
      }
      setState(() => isLoading = false);
      return;
    }

    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading, 
      message: "Guardando ingreso..."
    );
    final response = await widget.onSubmit.call(data);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (Navigator.canPop(context)) {
      context.pop();
    }

    if (response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.success, 
        message: "Ingreso guardado exitosamente", 
        autoDismiss: const Duration(seconds: 2)
      );
      ref.read(getHistoryEntryAccess.notifier).load();
    } else {
      await savePendingBiomar(data, 'entry');
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el ingreso'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }

    // if (!success) {
    //   await savePendingRequest(data, 'logbook_entry');
    // }

    // if (!mounted) return;

    // _clearCntrl();
    // if (Navigator.canPop(context)) {
    //   context.pop();
    // }

    // if (success) {
    //   context.push('/check-success');
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       duration: Duration(seconds: 6),
    //       content: Text(
    //         '📱 Error al enviar el formulario. La información se guardará localmente y se enviará automáticamente.',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Color.fromARGB(255, 255, 152, 0),
    //     ),
    //   );
    // }
  }

  List<Map<String, dynamic>> materialsAdded = [{
    'id_material': '0',
    'quantity': 1,
  }];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
        ),
      );
    }

    final areasVisit = ref.watch(getAreasVisit);
    final materials = ref.watch(getMaterials);
    final staffCharge = ref.watch(getStaffCharge);
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
      color: const Color.fromARGB(0, 150, 60, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 20,
              left: 16,
              right: 16,
            ),
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
                      'Registro de ingresos',
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

                CustomFieldLabelRequired(txtLabel: 'Tipo de visita'),
                GlowDropdownFormField2<String>(
                  value: _typeAccess,
                  focusNode: _typeAccessFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text(
                        'Seleccione una opción',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Proveedor',
                      child: Text(
                        'Proveedor',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Visitante',
                      child: Text(
                        'Visitante',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _typeAccess = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Cédula'),
                GlowTextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: _dniCtrl,
                  focusNode: _dniFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CustomFieldLabelRequired(txtLabel: 'Nombres Completos'),
                GlowTextFormField(
                  controller: _nameVisitCtrl,
                  focusNode: _truckLicenseFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                
                CustomFieldLabelRequired(txtLabel: 'Motivo ingreso'),
                GlowTextFormField(
                  controller: _reasonVisitCtrl,
                  focusNode: _reasonVisitFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Área de ingreso'),
                GlowDropdownFormField2<String>(
                  value: _areaVisit,
                  focusNode: _areaVisitFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text(
                        'Seleccione una opción',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ...areasVisit.map(
                      (c) => DropdownMenuItem(
                        value: c['id_area'].toString(),
                        child: Text(
                          c['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _areaVisit = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Personal responsable'),
                GlowDropdownFormField2<String>(
                  value: _personCharge,
                  focusNode: _personChargeFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text(
                        'Seleccione una opción',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ...staffCharge.map(
                      (c) => DropdownMenuItem(
                        value: c['id_staff'].toString(),
                        child: Text(
                          c['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _personCharge = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                CustomFieldLabelRequired(txtLabel: 'Materiales'),

                ...materialsAdded.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final selectedIds = materialsAdded
                      .asMap()
                      .entries
                      .where((e) => e.key != index) // excluir este item
                      .map((e) => e.value['id_material'])
                      .where((id) => id != '0')
                      .toList();

                  final availableMaterials = materials
                      .where((m) => !selectedIds.contains(m['id_material'].toString()))
                      .toList();

                  return MaterialEntryItem(
                    selectedMaterial: item['id_material'],
                    quantity: item['quantity'],
                    materials: availableMaterials,

                    onDeleteMaterial: materialsAdded.length > 1
                          ? () {
                              setState(() {
                                materialsAdded.removeAt(index);
                              });
                            }
                          : null,

                    onMaterialChanged: (v) {
                      setState(() {
                        materialsAdded[index]['id_material'] = v;
                      });
                    },

                    onQuantityChanged: (v) {
                      setState(() {
                        materialsAdded[index]['quantity'] = v;
                      });
                    },

                    onRemove: () {
                      setState(() {
                        materialsAdded.removeAt(index);
                      });
                    },

                  );
                }),

                if (materialsAdded.length < materials.length) ...[
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        materialsAdded.add({
                          'id_material': '0',
                          'quantity': 1,
                        });
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add_rounded, color: kTextSecondary, size: 18),
                          SizedBox(width: 2),
                          Text(
                            "Añadir Material",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color.fromARGB(255, 137, 172, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],

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
                
                CameraImagePicker(
                  minImages: 5,
                  maxImages: 10,
                  onImagesChanged: (images) {
                    print("imagenes seleccionadas ${images.length}");
                    _selectedImages = images;
                  },
                ),

                const SizedBox(height: 26),

                if (imagesMinError || imagesMaxError)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      imagesMinError
                          ? 'Debe subir mínimo 5 imagenes'
                          : 'Debe subir máximo 10 imagenes',
                      style: TextStyle(color: Color.fromARGB(255, 185, 28, 16)),
                    ),
                  ),
                  const SizedBox(height: 12,),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.pop();
                          _clearCntrl();
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading) ...[
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            const Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
