import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/service/pending_request_service.dart';

class EmployeeInternForm extends ConsumerStatefulWidget {
  final Future<ApiResponse<dynamic>> Function(Map<String, dynamic>) onSubmit;
  const EmployeeInternForm({super.key, required this.onSubmit});

  @override
  ConsumerState<EmployeeInternForm> createState() => _EmployeeInternFormState();
}

class _EmployeeInternFormState extends ConsumerState<EmployeeInternForm> {
  final _formKey = GlobalKey<FormState>();
  String _groupBusiness = '0';
  bool isLoading = false;
  bool imagesMinError = false;
  bool imagesMaxError = false;

  final _dniCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _namesCtrl = TextEditingController();
  final _lastnameCtrl = TextEditingController();

  List<Uint8List?> _selectedImages = [];

  final FocusNode _dniFocus = FocusNode();
  final FocusNode _positionFocus = FocusNode();
  final FocusNode _groupBusinessFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _categoryEntryFocus = FocusNode();
  final FocusNode _namesFocus = FocusNode();
  final FocusNode _lastnameFocus = FocusNode();
  bool isPickingImage = false;

  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        ref.read(getAllCategories.notifier).load(),
        ref.read(getGroupBusinessByIdBusiness.notifier).load(),
      ]);

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    });
  }

  @override
  void dispose() {
    _dniCtrl.dispose();
    _positionCtrl.dispose();
    _lastnameCtrl.dispose();
    _observationsCtrl.dispose();
    _categoryEntryFocus.dispose();
    _groupBusinessFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }

    if (_selectedImages.isEmpty) {
      setState(() {
        imagesMinError = true;
        isLoading = false;
      });
      return;
    }

    if (_selectedImages.length > 1) {
      setState(() {
        imagesMaxError = true;
        isLoading = false;
      });
      return;
    }

    
    if (_dniCtrl.text.length != 10) {
      setState(() => isLoading = false);
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'La cédula debe tener 10 caracteres',
        autoDismiss: const Duration(seconds: 3),
      );
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

    final data = {
      "external_transaction_id": Uuid().v4(),
      "dni": _dniCtrl.text.trim(),
      "lastname": _lastnameCtrl.text.trim(),
      "names": _namesCtrl.text.trim(),
      "position": _positionCtrl.text.trim(),
      "observations": _observationsCtrl.text.trim(),
      "user": userData.user,
      "name_user": userHive.value?.name ?? userData.attributes['fullname'],
      "group_business_id":
          userData.attributes['group_business'] ?? int.parse(_groupBusiness),
      "photo": _selectedImages
          .whereType<Uint8List>()
          .toList(), // Lista de Uint8List directo, sin base64
    };

    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading, 
      message: "Guardando registro..."
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
        message: "Registro guardado exitosamente", 
        autoDismiss: const Duration(seconds: 2)
      );
      ref.read(getHistoryDispatch.notifier).load();
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el registro. Intente nuevamente.'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  void _clearCntrl() {
    _selectedImages = [];
    _formKey.currentState?.reset();
    _groupBusiness = '0';
    _dniCtrl.clear();
    _lastnameCtrl.clear();
    _namesCtrl.clear();
    _observationsCtrl.clear();
    _namesCtrl.clear();
    imagesMinError = false;
    imagesMaxError = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

    final groupBusiness = ref.watch(getGroupBusinessByIdBusiness);
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

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        // vertical: 6,
                        // horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          if (userData.attributes['name_group_business'] !=
                              null) ...[
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
                                  CustomFieldLabelRequired(
                                    txtLabel: 'Localidad',
                                  ),
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
                    maxLength: 10,
                    controller: _dniCtrl,
                    keyboardType: TextInputType.number,
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
                    controller: _namesCtrl,
                    focusNode: _namesFocus,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Apellidos Completos'),
                  GlowTextFormField(
                    controller: _lastnameCtrl,
                    focusNode: _lastnameFocus,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Cargo'),
                  GlowTextFormField(
                    maxLength: 10,
                    controller: _positionCtrl,
                    focusNode: _positionFocus,
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

                  const SizedBox(height: 20),

                  CameraImagePicker(
                    textBtn: 'Captura fotográfica del personal',
                    minImages: 0,
                    maxImages: 1,
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
                            ? 'Debe subir mínimo 1 imagen'
                            : 'Debe subir máximo 1 imagen',
                        style: TextStyle(
                          color: Color.fromARGB(255, 185, 28, 16),
                        ),
                      ),
                    ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _clearCntrl();
                            context.pop();
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
                          onPressed: (isLoading || isPickingImage)
                              ? null
                              : _submit,
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
      ],
    );
  }
}
