import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NewProjectTechnical extends ConsumerStatefulWidget {
  final bool isSupport;
  final Future<ApiResponse<dynamic>> Function(Map<String, dynamic>) onSubmit;
  const NewProjectTechnical({super.key, required this.onSubmit, required this.isSupport});

  @override
  ConsumerState<NewProjectTechnical> createState() => _NewProjectTechnicalState();
}

class _NewProjectTechnicalState extends ConsumerState<NewProjectTechnical> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  int _clientSelection = 0;
  int _locationSelection = 0;

  final _observationsCtrl = TextEditingController();
  final _namesCtrl = TextEditingController();

  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _namesFocus = FocusNode();
  final FocusNode _clientSelectionFocus = FocusNode();
  final FocusNode _locationSelectionFocus = FocusNode();
  final FocusNode _clientFocus = FocusNode();

  InputDecoration styleDecoration() => InputDecoration(
    filled: true,
    fillColor: const Color.fromARGB(255, 20, 21, 23),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Color.fromARGB(190, 58, 199, 199)),
    ),
  );



  @override
  void initState() {
    ref.read(getClientsTechnical.notifier).load();
    super.initState();
  }

  @override
  void dispose() {
    _observationsCtrl.dispose();
    _locationSelectionFocus.dispose();
    _clientSelectionFocus.dispose();
    _clientFocus.dispose();
    _locationSelection = 0;
    _clientSelection = 0;
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

    final data = {
      "user": userData.user,
      "location_id": _locationSelection,
      "name": _namesCtrl.text.trim(),
      "description": _observationsCtrl.text.trim(),
      "is_support": widget.isSupport
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
      // ref.read(getHistoryDispatch.notifier).load();
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el registro. Intente nuevamente.'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  void _clearCntrl() {
    _formKey.currentState?.reset();
    _namesCtrl.clear();
    _observationsCtrl.clear();
    _namesCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userSessionProvider);
    final clientTech = ref.watch(getClientsTechnical);
    final locationTech = ref.watch(getLocationTechnical);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
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

                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Cliente'),
                  GlowDropdownFormField2<int>(
                    value: _clientSelection,
                    focusNode: _clientFocus,
                    decoration: styleDecoration(),
                    items: [
                      DropdownMenuItem(
                        enabled: false,
                        value: 0,
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ...clientTech.map(
                        (c) => DropdownMenuItem(
                          value: c.idClient,
                          child: Text(
                            c.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _clientSelection = v;
                          _locationSelection = 0;
                        });
                        ref.read(getLocationTechnical.notifier).load(
                          filters:{
                            "client_id": v,
                          }
                        );
                      }
                    },
                    validator: (v) {
                      if (v == 0 || v == null) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),


                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Ubicación'),
                  GlowDropdownFormField2<int>(
                    value: _locationSelection,
                    focusNode: _locationSelectionFocus,
                    decoration: styleDecoration(),
                    items: [
                      DropdownMenuItem(
                        enabled: false,
                        value: 0,
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ...locationTech.map(
                        (c) => DropdownMenuItem(
                          value: c.idLocation,
                          child: Text(
                            c.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _locationSelection = v);
                      }
                    },
                    validator: (v) {
                      if (v == 0 || v == null ) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Nombres del proyecto'),
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
                  CustomFieldLabelRequired(
                    txtLabel: 'Descripción',
                    isRequired: false,
                  ),
                  GlowTextFormField(
                    hint: "Agrega algun detalle adicional (opcional)",
                    controller: _observationsCtrl,
                    focusNode: _observationsFocus,
                    validator: (v) {
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

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
                          onPressed: isLoading
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