import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/all_logbook.dart';
import 'package:zentinel/presentation/providers/onboarding/onboarding_provider.dart';
import 'dart:io';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/service/pending_request_service.dart';

class ExitReportForm extends ConsumerStatefulWidget {
  final AllLogbook? preloadedData;
  final Future<bool> Function(Map<String, dynamic>)? onSubmit;
  const ExitReportForm({super.key, this.onSubmit, this.preloadedData});

  @override
  ConsumerState<ExitReportForm> createState() => _ExitReportFormState();
}

class _ExitReportFormState extends ConsumerState<ExitReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _categoryEntry = '0';
  String _groupBusiness = '0';
  String _unityId = '0';
  double _latitude = -0.1865936;
  double _longitude = -78.5953478;
  bool isLoading = false;
  bool imagesMinError = false;
  bool imagesMaxError = false;
  String _authorized = '0';

  final _guideCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _truckLicenseCtrl = TextEditingController();
  final _nameDriverCtrl = TextEditingController();
  final _destinyCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _personWithdrawsCtrl = TextEditingController();
  
  List<File?> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  final FocusNode _guideFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();
  final FocusNode _truckLicenseFocus = FocusNode();
  final FocusNode _nameDriverFocus = FocusNode();
  final FocusNode _authorizedFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _groupBusinessFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();
  final FocusNode _categoryEntryFocus = FocusNode();
  final FocusNode _personWithdrawsFocus = FocusNode();
  final FocusNode _unitFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    if (widget.preloadedData != null && mounted) {
      _loadPreloadedData(widget.preloadedData!);
    }
  }
  
  @override
  void dispose() {
    _guideCtrl.dispose();
    _quantityCtrl.dispose();
    _truckLicenseCtrl.dispose();
    _nameDriverCtrl.dispose();
    _observationsCtrl.dispose();
    _quantityFocus.dispose();
    _descFocus.dispose();
    _categoryEntryFocus.dispose();
    _groupBusinessFocus.dispose();
    super.dispose();
  }

  void _getUserLocation() async {
    final pos = await getLocation();

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

    _latitude = pos.latitude;
    _longitude = pos.longitude;
  }

  Future<void> _captureImageFromCamera() async {
    if (_selectedImages.length >= 5) {
      if (mounted) {
        setState(() {
          imagesMinError = false;
          imagesMaxError = false;
        });
      }
    }

    if (_selectedImages.length >= 10) {
      if (mounted) {
        setState(() {
          imagesMaxError = true;
        });
      }
      return;
    }

    if (_selectedImages.length == 10) {
      imagesMaxError = false;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (image != null && mounted) {
        // Agregar placeholder nulo para mostrar progreso en la UI
        setState(() {
          _selectedImages.add(null);
        });

        final placeholderIndex = _selectedImages.length - 1;

        final originalFile = File(image.path);

        // Convertir a WebP
        final webpFile = await convertToWebP(originalFile);

        if (webpFile == null) {
          if (mounted) {
            // Remover placeholder
            setState(() {
              if (placeholderIndex < _selectedImages.length &&
                  _selectedImages[placeholderIndex] == null) {
                _selectedImages.removeAt(placeholderIndex);
              }
            });

            showDialog(
              context: context,
              builder: (_) =>
                  ShowDialogWidget(title: 'Error al convertir imagen'),
            );
          }
          return;
        }

        final bytes = await webpFile.length();
        final mb = bytes / 1024 / 1024;

        print("Peso después de WebP: ${mb.toStringAsFixed(2)} MB");

        if (mounted) {
          setState(() {
            _selectedImages[placeholderIndex] = webpFile;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        // Remover último placeholder si existe
        if (_selectedImages.isNotEmpty && _selectedImages.last == null) {
          setState(() => _selectedImages.removeLast());
        }
        showDialog(
          context: context,
          builder: (_) => ShowDialogWidget(
            title: 'Error al capturar imagen',
            content: '$e',
          ),
        );
      }
    }
  }

  void _loadPreloadedData(AllLogbook data) {
    if (!mounted) return;

    setState(() {
      _categoryEntry = data.categoryId.toString();
      _guideCtrl.text = data.shippingGuide ?? '';
      _unityId = data.unityId.toString();
      _truckLicenseCtrl.text = data.truckLicense;
      _nameDriverCtrl.text = data.nameDriver ?? '';
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_latitude ==  -0.1865936 || _longitude == -78.5953478) {
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
    
    if (_selectedImages.length < 5) {
      setState(() => imagesMinError = true);
      return;
    }

    if (_selectedImages.length > 10) {
      setState(() => imagesMaxError = true);
      return;
    }

    final authState = ref.watch(userSessionProvider);

    //Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión no válida. Vuelva a iniciar sesión')),
      );
      return;
    }

    final userData = authState.value!;
    final userHive = ref.watch(userProfileProvider(userData.email));

    final data = {
      "id_logbook_entry": widget.preloadedData?.idLogbookEntry,
      "external_transaction_id": Uuid().v4(),
      "id_unity": int.parse(_unityId),
      "id_category": int.parse(_categoryEntry),
      "shipping_guide": _guideCtrl.text.trim(),
      "name_driver": _nameDriverCtrl.text.trim(),
      "quantity": int.tryParse(_quantityCtrl.text),
      "weight": int.tryParse(_weightCtrl.text),
      "truck_license": _truckLicenseCtrl.text.trim(),
      "lat": _latitude.toString(),
      "long": _longitude.toString(),
      "person_withdraws": _personWithdrawsCtrl.text.trim(),
      "destiny": _destinyCtrl.text.trim(),
      "authorized_by": _authorized,
      "observations": _observationsCtrl.text.trim(),
      "created_by": userData.user,
      "name_user": userHive.value?.name ?? userData.attributes['fullname'],
      "id_group_business": userData.attributes['group_business'] ?? int.parse(_groupBusiness),
      "images": _selectedImages
        .whereType<File>()
        .toList(), // Archivos serán convertidos a Base64 antes de guardar, // Archivos serán convertidos a Base64 antes de guardar
    };

    // Mostrar un diálogo de procesamiento
    if (mounted) {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const AlertDialog(
      //     content: Row(
      //       children: [
      //         CircularProgressIndicator(),
      //         SizedBox(width: 16),
      //         Text('Procesando formulario...'),
      //       ],
      //     ),
      //   ),
      // );
    }

    // Verificar conexión a internet
    final internetAvailable = await hasInternet();

    if (!internetAvailable) {
      // 🔴 SIN INTERNET: Guardar localmente
      print('❌ Sin conexión, guardando localmente...');
      data['created_at'] = DateTime.now().toString();
      await savePendingRequest(data, 'logbook_out');

      if (mounted) {
        // Navigator.pop(context); // Cerrar dialog de procesamiento
        _clearCntrl();
        context.pop(); // Cerrar el formulario
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
              '📱 Sin conexión. Tu información se guardará localmente y se enviará automáticamente cuando recuperes conexión.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 255, 152, 0),
          ),
        );
      }
      return;
    }

    // 🟢 CON INTERNET: Enviar al servidor
    print('✅ Conexión disponible, enviando al servidor...');
    setState(() => isLoading = true);
    final success = await widget.onSubmit?.call(data) ?? false;
    setState(() => isLoading = false);

    if (!success) {
      await savePendingRequest(data, 'logbook_out');
    }

    if (mounted) {
      _clearCntrl();
      context.pop(); // Cerrar el formulario
      
      if (success) {
        if (widget.preloadedData != null) {
          ref.read(getHistoryLogbooks.notifier).load();
          context.push('/check-success?redirect=/');
        }else{
          context.push('/check-success');
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 6),
            content: Text(
              '📱 Error al enviar el formulario. La información se guardará localmente y se enviará automáticamente.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 255, 152, 0),
          ),
        );
      }
    }
  }

  void _clearCntrl() {
    _selectedImages = [];
    _formKey.currentState?.reset();
    _categoryEntry = '0';
    _unityId = '0';
    _groupBusiness = '0';
    _guideCtrl.clear();
    _nameDriverCtrl.clear();
    _quantityCtrl.clear();
    _weightCtrl.clear();
    _truckLicenseCtrl.clear();
    _authorized = '0';
    _observationsCtrl.clear();
    _personWithdrawsCtrl.clear();
    _destinyCtrl.clear();
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
        const SnackBar(content: Text('Sesión no válida. Vuelva a iniciar sesión')),
      );
    }

    final userData = authState.value!;
    final categories = ref.watch(getAllCategories);
    final authorized = ref.watch(getAllAuthorized);

    if (widget.preloadedData != null && widget.preloadedData!.authorizedBy.isNotEmpty) {
      final authorizedExists = authorized.any(
        (item) => item.name == widget.preloadedData!.authorizedBy,
      );

      setState(() {
        _authorized = authorizedExists ? widget.preloadedData!.authorizedBy : '0';
      });
    }

    final groupBusiness = ref.watch(getGroupBusinessByIdBusiness);
    final unitiesWeight = ref.watch(getAllUnitiesWeight);    
    final messageValidatorEmpty = 'Este campo es obligatorio';
    final fieldFill = const Color.fromARGB(255, 20, 21, 23);
    final borderRadius = BorderRadius.circular(8.0);

    final categoryMap = {
      for (var c in categories) c.idCategory.toString(): c
    };

    final categoryName = categoryMap[_categoryEntry]?.nameCategory;    
    const hiddenWeightCategories = {
      'Ejecutivos de expalsa',
      'Personal interno',
      'Personal externo',
      'Cuadrillas para pesca'
    };

    const hiddenQuantityCategories = {
      'Camarón',
    };

    final hideWeight = hiddenWeightCategories.contains(categoryName);
    final hideQuantity = hiddenQuantityCategories.contains(categoryName);
    final isDestinyRequired = categoryName == 'Camarón';

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

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
                        ] 
                        else ...[
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
                                    if (v == '0' || v == null || v.trim().isEmpty) {
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
                CustomFieldLabelRequired(txtLabel: 'Categoría de salida'),
                GlowDropdownFormField2<String>(
                  value: _categoryEntry,
                  focusNode: _categoryEntryFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Seleccione una opción', style: TextStyle(color: Colors.white),),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(
                        value: c.idCategory.toString(),
                        child: Text(c.nameCategory, style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _categoryEntry = v);
                    }
                  },
                  validator: (v) {
                    if (v=='0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                if (!hideWeight) ...[
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
                ],

                if (hideQuantity) ...[
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
                ],

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Unidad'),
                GlowDropdownFormField<String>(
                  value: _unityId,
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
                    if (v != null) {
                      setState(() => _unityId = v);
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                if (!hideWeight) ...[
                  const SizedBox(height: 12),
                  CustomFieldLabelRequired(txtLabel: 'Peso', isRequired: false),
                  GlowTextFormField(
                    controller: _weightCtrl,
                    focusNode: _weightFocus,
                    keyboardType: TextInputType.number,
                    // hint: _unit == '0' ? '' : _unit,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 12),
                CustomFieldLabelRequired(txtLabel: 'Placa del Camión'),
                GlowTextFormField(
                  maxLength: 8,
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
                CustomFieldLabelRequired(
                  txtLabel: 'Destino',
                  isRequired: isDestinyRequired,
                ),
                GlowTextFormField(
                  controller: _destinyCtrl,
                  focusNode: _descFocus,
                  validator: (v) {
                    if (isDestinyRequired && (v == null || v.trim().isEmpty)) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                CustomFieldLabelRequired(
                  txtLabel: 'Autorizado por',
                ),
                GlowDropdownFormField2<String>(
                  value: _authorized,
                  focusNode: _authorizedFocus,
                  decoration: styleDecoration(),
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text('Seleccione una opción', style: TextStyle(color: Colors.white),),
                    ),
                    ...authorized.map(
                      (c) => DropdownMenuItem(
                        value: c.name,
                        child: Text(c.name, style: TextStyle(color: Colors.white),),
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
                CustomFieldLabelRequired(
                  txtLabel: 'Imágenes desde Cámara (${_selectedImages.length}/10)',
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // final granted = await requestCameraPermission(context);

                      // if (!granted) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text('Permiso de cámara denegado'),
                      //     ),
                      //   );
                      //   return;
                      // }

                      _captureImageFromCamera();
                    },
                    icon: const Icon(Icons.camera_alt, color: Color.fromARGB(189, 7, 213, 213)),
                    label: const Text(
                      'Capturar Imagen',
                      style: TextStyle(color: Color.fromARGB(189, 7, 213, 213)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(189, 7, 213, 213)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedImages.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Mostrar indicador de progreso cuando la imagen está siendo convertida (placeholder null)
                            _selectedImages[index] != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(
                                          _selectedImages[index]!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black26,
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                onPressed: () => _removeImage(index),
                                icon: const Icon(Icons.close, color: Colors.red),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                  iconSize: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No hay imágenes capturadas',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
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
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color.fromARGB(189, 7, 213, 213),
                          disabledBackgroundColor: const Color.fromARGB(120, 7, 213, 213),
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
