import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/service/pending_request_service.dart';

class EmployeeMovementForm extends ConsumerStatefulWidget {
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;
  final String typeMovement;
  final int idEmployee;

  const EmployeeMovementForm({
    super.key,
    required this.onSubmit,
    required this.typeMovement,
    required this.idEmployee,
  });

  @override
  ConsumerState<EmployeeMovementForm> createState() =>
      _EmployeeMovementFormState();
}

class _EmployeeMovementFormState extends ConsumerState<EmployeeMovementForm> {
  final _formKey = GlobalKey<FormState>();
  String _groupBusiness = '0';
  bool isLoading = false;
  bool imagesMinError = false;
  bool imagesMaxError = false;
  String _authorized = '0';
  String _destiny = '0';

  double _latitude = -0.1865936;
  double _longitude = -78.5953478;
  final _guideCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _otherDestinyCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _truckLicenseCtrl = TextEditingController();
  final _nameDriverCtrl = TextEditingController();

  final _dniCtrl = TextEditingController();
  final _namesCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();


  bool _isInitializing = true;

  List<Uint8List?> _selectedImages = [];

  final FocusNode _truckLicenseFocus = FocusNode();
  final FocusNode _nameDriverFocus = FocusNode();
  final FocusNode _employeeFocus = FocusNode();
  final FocusNode _destinyFocus = FocusNode();
  final FocusNode _authorizedFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _groupBusinessFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _otherDestinyFocus = FocusNode();
  final FocusNode _reasonFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _categoryEntryFocus = FocusNode();
  bool isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        ref.read(getEmployeeInternById.notifier).load(
          filters: {
            "id_employee": widget.idEmployee
          }
        ),
        ref.read(getGroupBusinessByIdBusiness.notifier).load(),
        ref.read(getAllAuthorized.notifier).load(),
      ]);

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    });
  }

  @override
  void dispose() {
    _guideCtrl.dispose();
    _reasonCtrl.dispose();
    _quantityCtrl.dispose();
    _weightCtrl.dispose();
    _providerCtrl.dispose();
    _nameDriverCtrl.dispose();
    _truckLicenseCtrl.dispose();
    _observationsCtrl.dispose();
    _quantityFocus.dispose();
    _descFocus.dispose();
    _categoryEntryFocus.dispose();
    _groupBusinessFocus.dispose();
    _truckLicenseFocus.dispose();
    _nameDriverFocus.dispose();
    _employeeFocus.dispose();
    super.dispose();
  }

  void _getUserLocation() async {
    final pos = await getLocation();

    if (!mounted) return;

    if (pos == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text("Ubicación no disponible"),
            content: Text("Activa el GPS o concede permisos."),
          ),
        );
      }
      return;
    }

    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });
  }

  void _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }

    // if (_latitude ==  -0.1865936 || _longitude == -78.5953478) {
    //   if (mounted) {
    //     showDialog(
    //       context: context,
    //       builder: (_) => const AlertDialog(
    //         title: Text("Ubicación no disponible"),
    //         content: Text("Activa el GPS o concede permisos."),
    //       ),
    //     );
    //   }
    //   setState(() => isLoading = false);
    //   return;
    // }
    if (_selectedImages.length < 3) {
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
    final userHive = ref.watch(userProfileProvider(userData.email));

    // Construir los datos del formulario
    final data = {
      "external_transaction_id": Uuid().v4(),
      "authorized_id": _authorized != '0' ? int.tryParse(_authorized) : null,
      "employee_id": widget.idEmployee,
      "group_business_id": _destiny != '0' && _destiny != '1000' ? int.tryParse(_destiny) : null,
      "name_user": userHive.value?.name ?? userData.attributes['fullname'],
      "other_destiny": _destiny == '1000' ? _otherDestinyCtrl.text.trim() : null,
      "observations": _observationsCtrl.text.trim(),
      "reason_out": _reasonCtrl.text.trim(),
      "type_movement": widget.typeMovement,
      "lat": _latitude.toString(),
      "long": _longitude.toString(),
      "user": userData.user,
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
      await savePendingEmployeeMovements(data);

      if (mounted) {
        // Navigator.pop(context); // Cerrar dialog de procesamiento
        _clearCntrl();
        if (Navigator.canPop(context)) {
          context.pop(); // Cerrar el formulario
        }
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.warning, 
          message: 'Sin conexión. Tu información se guardará localmente y se enviará automáticamente cuando recuperes conexión.', 
          autoDismiss: const Duration(seconds: 5)
        );
      }
      setState(() => isLoading = false);
      return;
    }

    // 🟢 CON INTERNET: Enviar al servidor
    print('✅ Conexión disponible, enviando al servidor...');

    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading, 
      message: "Guardando registro..."
    );

    ApiResponse<dynamic> response;

    try {
      response = await widget.onSubmit.call(data);
      setState(() => isLoading = false);

      if (!mounted) return;

      _clearCntrl();
      if (Navigator.canPop(context)) {
        context.pop();
      }

      if (response.success) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Registro guardado exitosamente", 
          autoDismiss: const Duration(seconds: 2)
        );
        ref.read(getEmployeeMovements.notifier).load();
        ref.read(getEmployeeInterns.notifier).load();
      } else {
        await savePendingEmployeeMovements(data);
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error: ${response.message ?? 'Error al guardar el registro.'}',
          autoDismiss: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      await savePendingEmployeeMovements(data);
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error al guardar el registro.',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  void _clearCntrl() {
    _selectedImages = [];
    _formKey.currentState?.reset();
    _groupBusiness = '0';
    _destiny = '0';
    _guideCtrl.clear();
    _reasonCtrl.clear();
    _quantityCtrl.clear();
    _weightCtrl.clear();
    _providerCtrl.clear();
    _nameDriverCtrl.clear();
    _truckLicenseCtrl.clear();
    _authorized = '0';
    _observationsCtrl.clear();
    imagesMinError = false;
    imagesMaxError = false;
  }

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

    final userData = authState.value!;
    final authorized = ref.watch(getAllAuthorized);
    final employeeInternById = ref.watch(getEmployeeInternById);
    final groupBusiness = ref.watch(getGroupBusinessByIdBusiness);
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

    if (_isInitializing) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 280,
                child: Text(
                  'Cargando formulario...',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      );
    }

    if (employeeInternById.isNotEmpty) {
      setState(() {
        _dniCtrl.text = employeeInternById[0].dni;
        _namesCtrl.text = '${employeeInternById[0].names} ${employeeInternById[0].lastname}';
        _positionCtrl.text = employeeInternById[0].position;
      });
    }else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 280,
                child: Text(
                  'Personal seleccionado no encontrado o no autorizado',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Form(
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
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 6,
                    // horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      if (userData.attributes['name_group_business'] != null) ...[
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          userData.attributes['name_group_business'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ] else ...[
                        Expanded(
                          child: Column(
                            children: [
                              CustomFieldLabelRequired(txtLabel: 'Localidad'),
                              const SizedBox(height: 6),
                              GlowDropdownFormField<String>(
                                value: _groupBusiness,
                                focusNode: _groupBusinessFocus,
                                decoration: styleDecoration(),
                                items: [
                                  const DropdownMenuItem(
                                    value: '0',
                                    child: Text('Seleccione una opción'),
                                  ),
                                  ...groupBusiness.map(
                                    (c) => DropdownMenuItem(
                                      value: c.idGroupBusiness.toString(),
                                      child: Text(c.name),
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _groupBusiness = v);
                                  }
                                },
                                validator: (v) {
                                  if (v == '0' ||
                                      v == null ||
                                      v.trim().isEmpty) {
                                    return messageValidatorEmpty;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              CustomFieldLabelRequired(txtLabel: 'Cédula'),
              GlowTextFormField(
                enabled: false,
                controller: _dniCtrl,
                focusNode: _descFocus,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              CustomFieldLabelRequired(txtLabel: 'Nombres completos'),
              GlowTextFormField(
                enabled: false,
                controller: _namesCtrl,
                focusNode: _descFocus,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              CustomFieldLabelRequired(txtLabel: 'Posición'),
              GlowTextFormField(
                enabled: false,
                controller: _positionCtrl,
                focusNode: _descFocus,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return messageValidatorEmpty;
                  }
                  return null;
                },
              ),
              
              if (widget.typeMovement == 'TRANSFER')...[
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Motivo'),
                GlowTextFormField(
                  controller: _reasonCtrl,
                  focusNode: _reasonFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
              ],

              if (widget.typeMovement == 'TRANSFER')...[
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Destino'),
                GlowDropdownFormField2<String>(
                  value: _destiny,
                  focusNode: _destinyFocus,
                  decoration: styleDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: '0',
                      child: Text(
                        'Seleccione una opción',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ...groupBusiness.map(
                      (c) => DropdownMenuItem(
                        value: c.idGroupBusiness.toString(),
                        child: Text(
                          c.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: '1000',
                      child: Text(
                        'Otros',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _destiny = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' ||
                        v == null ||
                        v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
              ],

              if (_destiny == '1000')...[
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Otro destino'),
                GlowTextFormField(
                  controller: _otherDestinyCtrl,
                  focusNode: _otherDestinyFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
              ],

              if (widget.typeMovement != 'CHECK_IN') ...[
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Autorizado por'),
                GlowDropdownFormField2<String>(
                  value: _authorized,
                  focusNode: _authorizedFocus,
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
                    ...authorized.map(
                      (c) => DropdownMenuItem(
                        value: c.name,
                        child: Text(
                          c.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _authorized = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
              ],
              
              if (widget.typeMovement == 'CHECK_IN' || widget.typeMovement == 'CHECK_OUT') ...[
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
              ],

              const SizedBox(height: 20),

              CameraImagePicker(
                minImages: 3,
                maxImages: 10,
                isPickingImage: isPickingImage,
                onPickingChanged: (value) {
                  setState(() {
                    isPickingImage = value;
                  });
                },
                onImagesChanged: (images) {
                  print("imagenes seleccionadas ${images.length}");
                  _selectedImages = images;
                },
              ),

              if (imagesMinError || imagesMaxError)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    imagesMinError
                        ? 'Debe subir mínimo 3 imagenes'
                        : 'Debe subir máximo 10 imagenes',
                    style: TextStyle(color: Color.fromARGB(255, 185, 28, 16)),
                  ),
                ),
              const SizedBox(height: 26),
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
                      onPressed: (isLoading || isPickingImage) ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color.fromARGB(189, 7, 213, 213),
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
    );
  }
}
