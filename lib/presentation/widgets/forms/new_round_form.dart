

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
  

  final observationsCtrl = TextEditingController();

  final FocusNode observationsFocus = FocusNode();


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _truckLicenseCtrl.dispose();
    // _driverCtrl.dispose();
    // _orderNumberCtrl.dispose();
    // _observationsCtrl.dispose();
    super.dispose();
  }

  void onSubmitRound() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (selectedImages.length < 5) {
      setState(() {
        imagesMinError = true;
        isLoading = false;
      });
      return;
    }

    if (selectedImages.length > 10) {
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
      // "observations": _observationsCtrl.text.trim(),
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
      message: "Guardando despacho..."
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
        message: "Ronda guardada exitosamente", 
        autoDismiss: const Duration(seconds: 2)
      );
      ref.read(getHistoryDispatch.notifier).load();
      Navigator.of(context).pop();
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar la ronda'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
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

                    CommentaryReception(
                      controller: observationsCtrl,
                      focusNode: observationsFocus,
                      hint: 'Observaciones generales sobre la recepción (opcional)',
                    ),
                    const SizedBox(height: 20),

                    CameraImagePicker(
                      minImages: 1,
                      maxImages: 3,
                      onImagesChanged: (images) {
                        print("imagenes seleccionadas ${images.length}");
                        selectedImages = images;
                      },
                    ),

                    const SizedBox(height: 10),

                    if (imagesMinError || imagesMaxError)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          imagesMinError
                              ? 'Debe subir mínimo 1 imagen'
                              : 'Debe subir máximo 3 imágenes',
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