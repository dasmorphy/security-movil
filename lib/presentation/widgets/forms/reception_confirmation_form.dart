import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/widgets/dispatch/dispatch_info_card.dart';
import 'package:zentinel/presentation/widgets/dispatch/received_product_item.dart';
import 'package:zentinel/presentation/widgets/headers/confirmation_header.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ReceivedProduct {
  final String id;
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
  final String dispatchId;
  final String origin;
  final String driver;
  final String status;
  final Color statusColor;

  const DispatchData({
    required this.dispatchId,
    required this.origin,
    required this.driver,
    required this.status,
    this.statusColor = const Color.fromARGB(255, 34, 197, 94),
  });
}

class ReceptionConfirmationForm extends ConsumerStatefulWidget {
  final DispatchData dispatchData;
  final List<ReceivedProduct> products;
  final Future<bool> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onBackPressed;

  const ReceptionConfirmationForm({
    super.key,
    required this.dispatchData,
    required this.products,
    this.onSubmit,
    this.onBackPressed,
  });

  @override
  ConsumerState<ReceptionConfirmationForm> createState() =>
      _ReceptionConfirmationFormState();
}

class _ReceptionConfirmationFormState
    extends ConsumerState<ReceptionConfirmationForm> {
  late List<ReceivedProduct> _products;
  bool _isLoading = false;

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

  Future<void> _handlePhotoPress(int productIndex) async {
    // Aquí se puede implementar la lógica para subir fotos
    // Por ahora solo mostramos un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Foto para: ${_products[productIndex].productName}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    // Validar que todos los productos con discrepancia tengan comentario y foto
    bool isValid = true;
    for (var product in _products) {
      if (product.hasDiscrepancy) {
        if (product.commentary.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${product.productName} requiere un comentario',
              ),
              backgroundColor: const Color.fromARGB(255, 220, 53, 69),
            ),
          );
          isValid = false;
          break;
        }
      }
    }

    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'dispatch_id': widget.dispatchData.dispatchId,
        'products': _products
            .map((p) => {
                  'id': p.id,
                  'product_name': p.productName,
                  'status': p.status,
                  'expected_qty': p.expectedQty,
                  'received_qty': p.receivedQty,
                  'commentary': p.commentary,
                  'has_discrepancy': p.hasDiscrepancy,
                  'photo_urls': p.photoUrls ?? [],
                })
            .toList(),
      };

      final success = await widget.onSubmit?.call(data) ?? true;

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recepción confirmada exitosamente'),
              backgroundColor: Color.fromARGB(255, 34, 197, 94),
            ),
          );
          // Future.delayed(const Duration(milliseconds: 500), () {
          //   if (mounted) Navigator.pop(context);
          // });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al confirmar la recepción'),
              backgroundColor: Color.fromARGB(255, 220, 53, 69),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color.fromARGB(255, 220, 53, 69),
          ),
        );
      }
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
                origin: widget.dispatchData.origin,
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
                      'Artículos a Recibir',
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
                    status: product.hasDiscrepancy ? 'CORRECTO' : 'DISCREPANCIA',
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
                        productName: hasDiscrepancy ? 'CORRECTO' : 'DISCREPANCIA',
                        status: product.status,
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
              const SizedBox(height: 32),

              // Botón de confirmación
              GestureDetector(
                onTap: _isLoading ? null : _handleSubmit,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 100, 200, 255),
                        Color.fromARGB(255, 76, 195, 233),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 76, 195, 233)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirmar Recepción',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
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
