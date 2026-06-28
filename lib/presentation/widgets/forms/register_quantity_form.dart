import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart' show formatDate;
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class RegisterQuantityForm extends ConsumerStatefulWidget {
  final HeaderInfoPurchaseOrder puchaseOrder;
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;

  const RegisterQuantityForm({
    super.key,
    required this.puchaseOrder,
    required this.onSubmit,
  });

  @override
  ConsumerState<RegisterQuantityForm> createState() => _RegisterQuantityFormState();
}

class _RegisterQuantityFormState extends ConsumerState<RegisterQuantityForm> {
  final _formKey = GlobalKey<FormState>();
  bool imagesMinError = false;
  bool imagesMaxError = false;
  bool _isLoading = false;
  bool isBlacklist = false;
  List<Uint8List?> _selectedImages = [];
  bool isPickingImage = false;

  final _nameDriverCtrl = TextEditingController();
  final _dniDriverCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _truckLicenseCtrl = TextEditingController();


  final FocusNode _truckLicenseFocus = FocusNode();
  final FocusNode _nameDriverFocus = FocusNode();
  final FocusNode _dniDriverFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _dniDriverFocus.addListener(() {
      if (!_dniDriverFocus.hasFocus) {
        _validateDni();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.reset();
  }

  void _validateDni() async {
    setState(() => isBlacklist = false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        ref.read(getBlacklistDriverByDni.notifier).load(filters: {
          'dni': _dniDriverCtrl.text
        }),
      ]);

      if (!mounted) return;

      final blacklistDni = ref.watch(getBlacklistDriverByDni);

      if (blacklistDni.isNotEmpty) {
        setState(() => isBlacklist = true);
        BlacklistBottomSheet.show(
          context,
          personName: blacklistDni[0].fullNames,
          documentId: blacklistDni[0].dni,
          restrictionReason: blacklistDni[0].reasonRestriction,
          registrationDate: formatDate(blacklistDni[0].createdAt),
          photoUrl: blacklistDni[0].imagePath != null ? 'http://st.telearseg.net${blacklistDni[0].imagePath}' : null
        );
      }else {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Cédula verificada correctamente", 
          autoDismiss: const Duration(seconds: 2)
        );
      }

    });
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _isLoading = false);
      return;
    }

    if (isBlacklist) {
      setState(() => isLoading = false);
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Conductor se encuentra lista negra',
        autoDismiss: const Duration(seconds: 3),
      );
      return;
    }

    if (_dniDriverCtrl.text.length < 10) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'La cédula debe ser de 10 dígitos',
        autoDismiss: const Duration(seconds: 3),
      );
      return;
    }

    // if (_selectedImages.length < 5) {
    //   setState(() {
    //     imagesMinError = true;
    //     _isLoading = false;
    //   });
    //   return;
    // }

    if (_selectedImages.length > 10) {
      setState(() {
        imagesMaxError = true;
        _isLoading = false;
      });
      return;
    }

    try {

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
        "purchase_order_id": widget.puchaseOrder.purchaseOrderId,
        "dni_driver": _dniDriverCtrl.text.trim(),
        "truck_license": _truckLicenseCtrl.text.trim(),
        "driver": _nameDriverCtrl.text.trim(),
        "quantity": _quantityCtrl.text.trim(),
        "user": userData.user,
        "images": _selectedImages.whereType<Uint8List>().toList(),
        "name_user": userHive.value?.name ?? userData.attributes['fullname'],
        "external_transaction_id": Uuid().v4(),
      };

      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.loading, 
        message: "Guardando registro..."
      );

      final response = await widget.onSubmit.call(data);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.success) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Registro guardado exitosamente", 
          autoDismiss: const Duration(seconds: 2)
        );
        ref.read(getPurchaseOrder.notifier).load();
        context.pop();
      } else {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error: ${response.message ?? 'Error al guardar el registro'}',
          autoDismiss: const Duration(seconds: 3),
        );
      }

    } catch (e) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error al guardar el registro: $e',
        autoDismiss: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Registro de cantidades',)
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header data del ingreso
                PuchaseOrderHeaderCard(purchaseOrder: widget.puchaseOrder,),
                const SizedBox(height: 24),
                CustomFieldLabelRequired(txtLabel: 'Cédula Chofer'),
                GlowTextFormField(
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: _dniDriverCtrl,
                  focusNode: _dniDriverFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
                if (isBlacklist)
                  SizedBox(
                    width: double.infinity,
                    child: const Text(
                      'Conductor en lista negra',
                      textAlign: TextAlign.left, 
                      style: TextStyle(
                        color: Color.fromARGB(255, 196, 39, 28)
                      ),
                    ),
                  ),
        
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Cantidad (Sacos)'),
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
                CustomFieldLabelRequired(txtLabel: 'Placa del Camión'),
                GlowTextFormField(
                  maxLength: 10,
                  uppercase: true,
                  controller: _truckLicenseCtrl,
                  focusNode: _truckLicenseFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    if (!v.contains('-')) {
                      return 'La placa debe contener un guion (-)';
                    }

                    if (!RegExp(r'\d').hasMatch(v)) {
                      return 'La placa debe contener al menos un número';
                    }
                    return null;
                  },
                ),
        
                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Nombre del Chofer'),
                GlowTextFormField(
                  uppercase: true,
                  controller: _nameDriverCtrl,
                  focusNode: _nameDriverFocus,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),
        
                const SizedBox(height: 20),
        
                CameraImagePicker(
                  minImages: 5,
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
        
                const SizedBox(height: 16),
        
                if (imagesMinError || imagesMaxError)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        imagesMinError
                            ? 'Debe subir mínimo 5 imagenes'
                            : 'Debe subir máximo 10 imagenes',
                        style: TextStyle(color: Color.fromARGB(255, 239, 28, 13)),
                      ),
                    ),
                    const SizedBox(height: 12,),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isLoading || isPickingImage) ? null : _handleSubmit,
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
                        if (_isLoading) ...[
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
