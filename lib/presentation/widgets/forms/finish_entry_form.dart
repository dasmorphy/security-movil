import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/entry_access_cards.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class FinishEntryForm extends ConsumerStatefulWidget {
  final EntryHeader entryAccessHeader;
  final List<MaterialEntry> materials;
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;
  final VoidCallback? onBackPressed;

  const FinishEntryForm({
    super.key,
    required this.entryAccessHeader,
    required this.materials,
    required this.onSubmit,
    this.onBackPressed,
  });

  @override
  ConsumerState<FinishEntryForm> createState() => _FinishEntryFormState();
}

class _FinishEntryFormState extends ConsumerState<FinishEntryForm> {
  bool imagesMinError = false;
  bool imagesMaxError = false;
  List<bool> checkedList = [];
  late List<MaterialEntry> _materials;
  bool _isLoading = false;
  List<Uint8List?> _selectedImages = [];
  final TextEditingController _observationsCtrl = TextEditingController();
  final FocusNode _observationsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _materials = widget.materials;
    checkedList = List.generate(_materials.length, (_) => false);
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final allChecked = checkedList.every((e) => e);

    if (!allChecked) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Todos los materiales deben ser marcados para finalizar el ingreso',
        autoDismiss: const Duration(seconds: 4),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (_selectedImages.length < 5) {
      setState(() {
        imagesMinError = true;
        _isLoading = false;
      });
      return;
    }

    if (_selectedImages.length > 10) {
      setState(() {
        imagesMaxError = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final data = {
        'entry_access_id': widget.entryAccessHeader.entryAccessId,
        'images': _selectedImages.whereType<Uint8List>().toList(),
        'observations': _observationsCtrl.text.trim(),
        'external_transaction_id': Uuid().v4(),
      };

      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.loading, 
        message: "Guardando salida..."
      );

      final response = await widget.onSubmit.call(data);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.success) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Salida guardada exitosamente", 
          autoDismiss: const Duration(seconds: 2)
        );
        ref.read(getHistoryEntryAccess.notifier).load();
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.go('/');
      } else {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error: ${response.message ?? 'Error al guardar la salida'}',
          autoDismiss: const Duration(seconds: 3),
        );
      }

    } catch (e) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error al guardar la salida: $e',
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
        child: const HeaderOptionsProfile(headerTxt: 'Registrar Salida',)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header data del ingreso
              EntryAccessHeaderCard(entryAccessData: widget.entryAccessHeader,),
              const SizedBox(height: 24),

              // Título de artículos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Materiales / Equipos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_materials.length} Material(es)',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lista de productos
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _materials.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final material = _materials[index];
                  return FinishMaterialItemCard(
                    materialName: material.name,
                    quantity: material.quantity,
                    isChecked: checkedList[index],
                    onChanged: (value) {
                      setState(() {
                        checkedList[index] = value;
                      });
                    },
                  );
                },
              ),

              CommentaryReception(
                controller: _observationsCtrl,
                focusNode: _observationsFocus,
                label: 'Observaciones',
                hint: 'Observaciones generales (opcional)',
                onChanged: (value) {
                  setState(() {
                    _observationsCtrl.text = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              CameraImagePicker(
                minImages: 5,
                maxImages: 10,
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
                  onPressed: _isLoading ? null : _handleSubmit,
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
                        'Guardar salida',
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
    );
  }
}
