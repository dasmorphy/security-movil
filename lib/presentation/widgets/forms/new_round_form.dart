

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';



class NewRoundForm extends ConsumerStatefulWidget {
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;

  const NewRoundForm({super.key, required this.onSubmit});

  @override
  ConsumerState<NewRoundForm> createState() => _NewRoundFormState();
}

class _NewRoundFormState extends ConsumerState<NewRoundForm> {

  bool isLoading = false;
  List<Uint8List?> selectedImages = [];
  bool imagesMinError = false;
  bool imagesMaxError = false;
  
  
  double latitude = -0.1865936;
  double longitude = -78.5953478;

  final observationsCtrl = TextEditingController();
  final poolCtrl = TextEditingController();
  String _sectorPool = '0';



  final FocusNode observationsFocus = FocusNode();
  final FocusNode poolFocus = FocusNode();
  final FocusNode _sectorPoolFocus = FocusNode();


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


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    // _truckLicenseCtrl.dispose();
    // _driverCtrl.dispose();
    // _orderNumberCtrl.dispose();
    // _observationsCtrl.dispose();
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
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  void onSubmitRound() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (selectedImages.length < 3) {
      setState(() {
        imagesMinError = true;
        isLoading = false;
      });
      return;
    }

    if (selectedImages.length > 6) {
      setState(() {
        imagesMaxError = true;
        isLoading = false;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }

    final authState = ref.read(userSessionProvider);

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
      // "order_number": _orderNumberCtrl.text.trim(),
      "external_transaction_id": Uuid().v4(),
      // "destiny": _destinySelected,
      // "driver": _driverCtrl.text.trim(),
      "observations": observationsCtrl.text.trim(),
      "pool": poolCtrl.text.trim(),
      "lat": latitude,
      "long": longitude,
      "out_round": false,
      "sector_pool_id": int.tryParse(_sectorPool),
      // "truck_license": _truckLicenseCtrl.text.trim(),
      // "vehicle_type": _vehicleSelected,
      // "weight": int.tryParse(_weightCtrl.text),
      "user": userData.user,
      "images": selectedImages
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

    // if (!success) {
    //   await savePendingRequest(data, 'logbook_entry');
    // }


    if (response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.success, 
        message: "Registro guardado exitosamente", 
        autoDismiss: const Duration(seconds: 2)
      );
      // ref.read(getHistoryDispatch.notifier).load();
      Navigator.of(context).pop();
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el registro'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final sectorPools = ref.watch(getSectorPool);

    return  Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    CustomFieldLabelRequired(txtLabel: 'Piscina'),
                    GlowTextFormField(
                      controller: poolCtrl,
                      focusNode: poolFocus,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return messageValidatorEmpty;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),
                    CustomFieldLabelRequired(txtLabel: 'Sector de piscina'),
                    GlowDropdownFormField2<String>(
                      value: _sectorPool,
                      focusNode: _sectorPoolFocus,
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
                        ...sectorPools.map(
                          (c) => DropdownMenuItem(
                            value: c["id_sector"].toString(),
                            child: Text(
                              c["name"],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _sectorPool = v);
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
                    CommentaryReception(
                      controller: observationsCtrl,
                      focusNode: observationsFocus,
                      hint: 'Observaciones generales sobre la recepción (opcional)',
                    ),
                    const SizedBox(height: 20),

                    CameraImagePicker(
                      minImages: 3,
                      maxImages: 6,
                      onImagesChanged: (images) {
                        selectedImages = images;
                      },
                    ),

                    const SizedBox(height: 10),

                    if (imagesMinError || imagesMaxError)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          imagesMinError
                              ? 'Debe subir mínimo 3 imagen'
                              : 'Debe subir máximo 6 imágenes',
                          style: TextStyle(color: Color.fromARGB(255, 239, 28, 13)),
                        ),
                      ),

                    const SizedBox(height: 12),


                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : onSubmitRound,
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
                                'Crear Registro',
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
                    )

                  ]
                )
              )
            )
          )
        ]
    );
  }
}