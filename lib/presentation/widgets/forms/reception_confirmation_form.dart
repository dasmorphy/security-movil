import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ReceivedProduct {
  final int id;
  final String productName;
  final String status;
  final int expectedQty;
  int receivedQty;
  String commentary;
  bool hasDiscrepancy;
  List<String>? photoUrls;

  ReceivedProduct({
    required this.id,
    required this.productName,
    required this.status,
    required this.expectedQty,
    this.receivedQty = 0,
    this.commentary = '',
    this.hasDiscrepancy = false,
    this.photoUrls,
  });
}

class DispatchData {
  final int dispatchId;
  final String orderNumber;
  final String destiny;
  final String driver;
  final String status;
  final Color statusColor;

  const DispatchData({
    required this.dispatchId,
    required this.orderNumber,
    required this.destiny,
    required this.driver,
    required this.status,
    this.statusColor = const Color.fromARGB(255, 34, 197, 94),
  });
}

class ReceptionConfirmationForm extends ConsumerStatefulWidget {
  final DispatchData dispatchData;
  final List<ReceivedProduct> products;
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;
  final VoidCallback? onBackPressed;

  const ReceptionConfirmationForm({
    super.key,
    required this.dispatchData,
    required this.products,
    required this.onSubmit,
    this.onBackPressed,
  });

  @override
  ConsumerState<ReceptionConfirmationForm> createState() => _ReceptionConfirmationFormState();
}

class _ReceptionConfirmationFormState extends ConsumerState<ReceptionConfirmationForm> {
  late List<ReceivedProduct> _products;
  bool _isLoading = false;
  List<Uint8List?> _selectedImages = [];
  final TextEditingController _observationsCtrl = TextEditingController();
  final FocusNode _observationsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _products = widget.products.map((p) {
      return ReceivedProduct(
        id: p.id,
        productName: p.productName,
        status: p.status,
        expectedQty: p.expectedQty,
        receivedQty: p.receivedQty,
        commentary: p.commentary,
        hasDiscrepancy: p.hasDiscrepancy,
        photoUrls: p.photoUrls,
      );
    }).toList();
  }

  void _updateProduct(int index, ReceivedProduct product) {
    setState(() {
      _products[index] = product;
    });
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    // Validar que todos los productos con discrepancia tengan comentario y foto
    bool isValid = true;
    for (var product in _products) {
      if (product.hasDiscrepancy) {
        if (product.commentary.isEmpty) {
          GlobalLoadingBottomSheet.show(
            status: OverlayStatus.error,
            message: '${product.productName} requiere un comentario',
            autoDismiss: const Duration(seconds: 3),
          );
          isValid = false;
          break;
        }
      }
    }

    if (!isValid) return;

    setState(() => _isLoading = true);
    bool hasDiscrepancies = _products.any((p) => p.hasDiscrepancy);
    try {
      final data = {
        'dispatch_id': widget.dispatchData.dispatchId,
        'is_correct': !hasDiscrepancies,
        'images': _selectedImages.whereType<Uint8List>().toList(),
        'observations': _observationsCtrl.text.trim(),
        'external_transaction_id': Uuid().v4(),
        'reception_details': hasDiscrepancies
          ? _products
            .map((p) => {
              'product_id': p.id,
              'expected_quantity': p.expectedQty,
              'received_quantity': p.receivedQty,
              'observations': p.commentary,
              // 'photo_urls': p.photoUrls ?? [],
            })
            .toList()
          : null,
      };

      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.loading, 
        message: "Guardando recepción..."
      );

      final response = await widget.onSubmit.call(data);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.success) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Recepción confirmada exitosamente", 
          autoDismiss: const Duration(seconds: 2)
        );
        ref.read(getHistoryDispatch.notifier).load();
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.go('/');
      } else {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error: ${response.message ?? 'Error al confirmar la recepción'}',
          autoDismiss: const Duration(seconds: 3),
        );
      }

    } catch (e) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error al guardar la recepción: $e',
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
      backgroundColor: const Color.fromARGB(255, 20, 21, 23),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Confirmar Recepción',)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del despacho
              DispatchInfoCard(
                dispatchId: widget.dispatchData.dispatchId,
                orderNumber: widget.dispatchData.orderNumber,
                destiny: widget.dispatchData.destiny,
                driver: widget.dispatchData.driver,
                status: widget.dispatchData.status,
                statusColor: widget.dispatchData.statusColor,
              ),
              const SizedBox(height: 24),

              // Título de artículos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Productos a Recibir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_products.length} Productos',
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
                itemCount: _products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ReceivedProductItem(
                    productName: product.productName,
                    status: product.hasDiscrepancy ? 'DISCREPANCIA' : 'CORRECTO',
                    expectedQty: product.expectedQty,
                    receivedQty: product.receivedQty,
                    commentary: product.commentary,
                    hasDiscrepancy: product.hasDiscrepancy,
                    onReceivedQtyChanged: (qty) {
                      final updatedProduct = ReceivedProduct(
                        id: product.id,
                        productName: product.productName,
                        status: product.status,
                        expectedQty: product.expectedQty,
                        receivedQty: qty,
                        commentary: product.commentary,
                        hasDiscrepancy: product.hasDiscrepancy,
                        photoUrls: product.photoUrls,
                      );
                      _updateProduct(index, updatedProduct);
                    },
                    onCommentaryChanged: (commentary) {
                      final updatedProduct = ReceivedProduct(
                        id: product.id,
                        productName: product.productName,
                        status: product.status,
                        expectedQty: product.expectedQty,
                        receivedQty: product.receivedQty,
                        commentary: commentary,
                        hasDiscrepancy: product.hasDiscrepancy,
                        photoUrls: product.photoUrls,
                      );
                      _updateProduct(index, updatedProduct);
                    },
                    // onPhotoPressed: () => _handlePhotoPress(index),
                    onToggleChanged: (hasDiscrepancy) {
                      final updatedProduct = ReceivedProduct(
                        id: product.id,
                        productName: product.productName,
                        status: hasDiscrepancy ? 'DISCREPANCIA' : 'CORRECTO',
                        expectedQty: product.expectedQty,
                        receivedQty: product.receivedQty,
                        commentary: product.commentary,
                        hasDiscrepancy: hasDiscrepancy,
                        photoUrls: product.photoUrls,
                      );
                      _updateProduct(index, updatedProduct);
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              CommentaryReception(
                controller: _observationsCtrl,
                focusNode: _observationsFocus,
                hint: 'Observaciones generales sobre la recepción (opcional)',
                onChanged: (value) {
                  setState(() {
                    _observationsCtrl.text = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              CameraImagePicker(
                minImages: 5,
                maxImages: 10,
                onImagesChanged: (images) {
              
                  print("imagenes seleccionadas ${images.length}");
              
                  _selectedImages = images;
              
                },
              ),

              const SizedBox(height: 16),

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
                        'Confirmar Recepción',
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
