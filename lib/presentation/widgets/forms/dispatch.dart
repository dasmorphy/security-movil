import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:zentinel/service/pending_request_service.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────

class ProductoItem {
  String? productoId;
  int cantidad;
  ProductoItem({this.productoId, this.cantidad = 1});
}

class SkuItem {
  String typeSku;
  SkuItem({this.typeSku = 'Individual'});
}

// ─── Colores ───────────────────────────────────────────────────────────────

const Color kNavy = Color(0xFF1A237E);
const Color kNavyLight = Color(0xFFE8EAF6);
const Color kGrayBg = Color(0xFFF4F4F6);
const Color kGrayBorder = Color(0xFFE0E0E0);
const Color kTextPrimary = Color(0xFF1A1A2E);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kTextHint = Color(0xFF9CA3AF);
const Color kGreen = Color(0xFF4CAF50);
const Color kGreenLight = Color(0xFFE8F5E9);
const messageValidatorEmpty = 'Este campo es obligatorio';

bool isLoading = false;
List<Uint8List?> _selectedImages = [];

// ─── Screen principal ──────────────────────────────────────────────────────

class DispatchForm extends ConsumerStatefulWidget {
  final bool? isProductTerm;
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;
  const DispatchForm({super.key, required this.onSubmit, this.isProductTerm = false});

  @override
  ConsumerState<DispatchForm> createState() => _CrearDespachoScreenState();
}

class _CrearDespachoScreenState extends ConsumerState<DispatchForm> {
  bool imagesMinError = false;
  bool imagesMaxError = false;
  final _formKey = GlobalKey<FormState>();

  final List<SkuItem> _skus = [
    SkuItem(),
  ];

  int? _vehicleSelected = 0;
  int? _destinySelected = 0;
  String _destinyProduct = '0';
  final String _driver = '';
  final String _truckLicense = '';
  final String _orderNumber = '';
  final _truckLicenseCtrl = TextEditingController();
  final _driverCtrl = TextEditingController();
  final _orderNumberCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _clientCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _truckLicenseCtrl.dispose();
    _driverCtrl.dispose();
    _orderNumberCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  void _agregarProducto(int skuIndex) {
    if (skuIndex < 0 || skuIndex >= _skus.length) return;
    setState(() {
      _skus[skuIndex];
    });
  }

  void _skuChangeChecked(int skuIndex, bool check) {
    if (skuIndex < 0 || skuIndex >= _skus.length) return;

    setState(() {
      _skus[skuIndex].typeSku =
        check ? 'Multiple' : 'Individual';
    });
  }

  void _addSku() {
    setState(() {
      _skus.add(SkuItem());
    });
  }

  void _deleteSku(int index) {
    if (_skus.length <= 1) return;
    setState(() {
      _skus.removeAt(index);
    });
  }

  void _crearDespacho() async {
    if (isLoading) return;
    setState(() => isLoading = true);

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

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }

    // Recolectar todos los productos válidos de todos los SKUs
    // final productosValidos = <ProductoItem>[];
    // for (final sku in _skus) {
    //   productosValidos.addAll(
    //     sku.productos.where((p) => p.productoId != null)
    //   );
    // }

    // if (productosValidos.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Agrega al menos un producto a los SKUs')),
    //   );
    //   return;
    // }

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

    final skusData = _skus.map((sku) {
      return {
        "type_sku": sku.typeSku,
        // "products": sku.productos
        //   .where((p) => p.productoId != null)
        //   .map((p) => {
        //     "id_product": int.parse(p.productoId!),
        //     "quantity": p.cantidad,
        //   })
        //   .toList(),
      };
    }).toList();
    
    final dynamic destinyProduct = _destinyProduct != '0' ? _destinyProduct : null;

    final data = {
      "order_number": _orderNumberCtrl.text.trim(),
      "external_transaction_id": Uuid().v4(),
      "destiny": _destinySelected == 0 ? null : _destinySelected,
      "driver": _driverCtrl.text.trim(),
      "observations": _observationsCtrl.text.trim(),
      "truck_license": _truckLicenseCtrl.text.trim(),
      "vehicle_type": _vehicleSelected,
      "type_process": widget.isProductTerm != true ? 'dispatch' : 'product',
      "destiny_product": widget.isProductTerm != true && destinyProduct == null ? null : _clientCtrl.text.trim(),
      "sku": skusData,
      // "weight": int.tryParse(_weightCtrl.text),
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
      await savePendingRequest(data, 'dispatch');

      if (mounted) {
        // _truckLicenseCtrl.dispose();
        // _driverCtrl.dispose();
        // _orderNumberCtrl.dispose();
        // _observationsCtrl.dispose();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 6),
            content: Text(
              '📱 Sin conexión. Tu información se guardará localmente y se enviará automáticamente cuando recuperes conexión.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 255, 152, 0),
          ),
        );
      }
      setState(() => isLoading = false);
      return;
    }

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

    if (Navigator.canPop(context)) {
      context.pop();
    }

    if (response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.success, 
        message: "Despacho guardado exitosamente", 
        autoDismiss: const Duration(seconds: 2)
      );
      ref.read(getHistoryDispatch.notifier).load();
    } else {
      await savePendingBiomar(data, 'dispatch');
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error: ${response.message ?? 'Error al guardar el despacho. La información se guardará localmente y se enviará automáticamente.'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesTypes = ref.watch(getAllVehicleTypes);
    final destiny = ref.watch(getAllDestinyIntern);

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
                    NewSkuListCard(
                      skus: _skus,
                      onDeleteSku: _deleteSku,
                      onAddSku: _addSku,
                      onAgregarProducto: _agregarProducto,
                      onSkuCheckedChanged: _skuChangeChecked
                    ),
                    const SizedBox(height: 6),
                    InformacionLogisticaCard(
                      clientCtrl: _clientCtrl,
                      isProductTerm: widget.isProductTerm,
                      imagesMaxError: imagesMaxError,
                      imagesMinError: imagesMinError,
                      driver: _driver,
                      truckLicense: _truckLicense,
                      orderNumber: _orderNumber,
                      orderNumberCtrl: _orderNumberCtrl,
                      truckLicenseCtrl: _truckLicenseCtrl,
                      driverCtrl: _driverCtrl,
                      observationsCtrl: _observationsCtrl,
                      vehicleSelected: _vehicleSelected,
                      catalogVehicles: vehiclesTypes,
                      onVehicleChanged: (c) => setState(() => 
                        _vehicleSelected = c
                      ),
                      onDestinyChanged: (c) => setState(() => 
                        _destinySelected = c
                      ),
                      onDestinyProductChange: (c) => setState(() => 
                        _destinyProduct = c
                      ),
                      catalogDestiny: destiny, 
                      destinySelected: _destinySelected,
                      destinyProduct: _destinyProduct,
                      onImagesChanged: (images) {
                        print("imagenes seleccionadas ${images.length}");
                        _selectedImages = images;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          _BottomBar(onCrear: _crearDespacho),
        ],
      );
  }
}

// ─── Barra inferior ────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final VoidCallback onCrear;
  const _BottomBar({required this.onCrear});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onCrear,
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
                'Crear Despacho',
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
    );
  }
}