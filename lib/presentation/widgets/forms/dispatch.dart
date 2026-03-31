import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/domain/entities/destiny_intern.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────

class ProductoItem {
  String? productoId;
  int cantidad;
  ProductoItem({this.productoId, this.cantidad = 1});
}

class SkuItem {
  String? skuId;
  SkuItem({this.skuId});
}

class ProductoCatalogo {
  final String id;
  final String nombre;
  ProductoCatalogo({required this.id, required this.nombre});
}

class Conductor {
  final String id;
  final String nombre;
  final String patente;
  Conductor({required this.id, required this.nombre, required this.patente});
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
final _truckLicenseCtrl = TextEditingController();
bool isLoading = false;

// ─── Screen principal ──────────────────────────────────────────────────────

class DispatchForm extends ConsumerStatefulWidget {
  final Future<ApiResponse> Function(Map<String, dynamic>)? onSubmit;
  const DispatchForm({super.key, this.onSubmit});

  @override
  ConsumerState<DispatchForm> createState() => _CrearDespachoScreenState();
}

class _CrearDespachoScreenState extends ConsumerState<DispatchForm> {
  bool _modoNuevo = true;
  final _formKey = GlobalKey<FormState>();

  final List<ProductoItem> _productos = [
    ProductoItem(),
  ];

  final List<SkuItem> _skus = [
    SkuItem(),
  ];

  int? _vehicleSelected = 0;
  int? _destinySelected = 0;
  final String _driver = '';

  String get _tipoSku {
    final conProducto = _productos.length;
    return conProducto > 1 ? 'SKU Mixto' : 'SKU Independiente';
  }

  bool get _esMultiple {
    return _productos.where((p) => p.productoId != null).length > 1;
  }

  void _agregarProducto() {
    setState(() {
      _productos.add(ProductoItem());
    });
  }

  void _addSku() {
    setState(() {
      _skus.add(SkuItem());
    });
  }

  void _deleteProduct(int index) {
    if (_productos.length <= 1) return;
    setState(() {
      _productos.removeAt(index);
    });
  }

  void _deleteSku(int index) {
    if (_skus.length <= 1) return;
    setState(() {
      _skus.removeAt(index);
    });
  }

  void _onCantidadChanged(int index, String val) {
    final n = int.tryParse(val);
    if (n != null && n > 0) {
      setState(() {
        _productos[index].cantidad = n;
      });
    }
  }

  void _crearDespacho() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => isLoading = false);
      return;
    }
    final productosValidos = _productos.where((p) => p.productoId != null).toList();
    if (productosValidos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto al SKU')),
      );
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
      "external_transaction_id": Uuid().v4(),
      "destiny": _destinySelected,
      "driver": _truckLicenseCtrl.text.trim(),
      "products_sku": productosValidos.map((p) => {
        "id_product": int.parse(p.productoId!),
        "quantity": p.cantidad,
      }).toList(),
      "sku_type": _tipoSku,
      "vehicle_type": _vehicleSelected,
      // "weight": int.tryParse(_weightCtrl.text),
      "user": userData.user,
      // "images": _selectedImages
      //   .whereType<Uint8List>()
      //   .toList(), // Lista de Uint8List directo, sin base64
    };

    final success = await widget.onSubmit?.call(data);
    setState(() => isLoading = false);

    // if (!success) {
    //   await savePendingRequest(data, 'logbook_entry');
    // }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Despacho creado · ${productosValidos.length} producto(s)',
        ),
        backgroundColor: kNavy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dispatchProducts = ref.watch(getAllDispatchProducts);
    final vehiclesTypes = ref.watch(getAllVehicleTypes);
    final destiny = ref.watch(getAllDestinyIntern);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kGrayBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: kTextPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Nuevo despacho',
          style: TextStyle(
            color: kTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: kGrayBorder),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _SKUModeSelector(
                    //   modoNuevo: _modoNuevo,
                    //   onChanged: (val) => setState(() => _modoNuevo = val)
                    // ),
                    const SizedBox(height: 16),
                    ProductsNewSku(
                      catalogProducts: dispatchProducts,
                      flagNewSku: _modoNuevo,
                      productos: _productos,
                      skus: _skus,
                      tipoSku: _tipoSku,
                      esMultiple: _esMultiple,
                      onCantidadChanged: _onCantidadChanged,
                      onDeleteProduct: _deleteProduct,
                      onDeleteSku: _deleteSku,
                      onAgregarProducto: _agregarProducto,
                      onAddSku: _addSku,
                    ),
                    const SizedBox(height: 16),
                    _InformacionLogisticaCard(
                      driver: _driver,
                      vehicleSelected: _vehicleSelected,
                      catalogVehicles: vehiclesTypes,
                      onVehicleChanged: (c) => setState(() => 
                        _vehicleSelected = c
                      ),
                      onDestinyChanged: (c) => setState(() => 
                        _destinySelected = c
                      ),
                      catalogDestiny: destiny, 
                      destinySelected: _destinySelected,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          _BottomBar(onCrear: _crearDespacho),
        ],
      ),
    );
  }
}

// ─── Selector de modo SKU ──────────────────────────────────────────────────

// class _SKUModeSelector extends StatelessWidget {
//   final bool modoNuevo;
//   final Function(bool) onChanged;

//   const _SKUModeSelector({
//     required this.modoNuevo, 
//     required this.onChanged
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: _ModeCard(
//           icon: Icons.add,
//           label: 'Agregar\nSKU',
//           selected: modoNuevo,
//           onTap: () => onChanged(true),
//         )),
//         const SizedBox(width: 12),
//         Expanded(child: _ModeCard(
//           icon: Icons.playlist_add_check_rounded,
//           label: 'Seleccionar\nExistente',
//           selected: !modoNuevo,
//           onTap: () => onChanged(false),
//         )),
//       ],
//     );
//   }
// }

// class _ModeCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _ModeCard({
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//         decoration: BoxDecoration(
//           color: selected ? kNavy : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: selected ? kNavy : kGrayBorder,
//             width: 0.5,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: selected ? Colors.white : kNavy, size: 26),
//             const SizedBox(height: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? Colors.white : kNavy,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 height: 1.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ─── Información logística ─────────────────────────────────────────────────

class _InformacionLogisticaCard extends StatelessWidget {
  final String driver;
  final int? vehicleSelected;
  final int? destinySelected;
  final List<VehicleType> catalogVehicles;
  final List<DestinyIntern> catalogDestiny;
  final void Function(int) onDestinyChanged;
  final void Function(int) onVehicleChanged;

  const _InformacionLogisticaCard({
    required this.driver,
    required this.vehicleSelected,
    required this.onDestinyChanged, 
    required this.catalogVehicles, 
    required this.onVehicleChanged, 
    required this.catalogDestiny, 
    required this.destinySelected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGrayBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              'INFORMACIÓN LOGÍSTICA',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
          _LogisticaFila(
            icono: Icons.person_rounded,
            label: 'CONDUCTOR',
            valor: driver,
          ),
          
          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.location_on_rounded, color: kNavy, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Destino'.toUpperCase(),
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      GlowDropdownFormField2<String>(
                        value: destinySelected.toString(),
                        textColor: Colors.black,
                        items: [
                          DropdownMenuItem(
                            enabled: false,
                            value: '0',
                            child: Text(
                              'Seleccione una opción',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ...catalogDestiny.map(
                            (c) => DropdownMenuItem(
                              value: c.idDestiny.toString(),
                              child: Text(
                                c.name,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (id) {
                          if (id != null) {
                            onDestinyChanged(int.parse(id));
                          }
                        },
                        validator: (v) {
                          if (v == '0' || v == null || v.trim().isEmpty) {
                            return messageValidatorEmpty;
                          }
                          return null;
                        },
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.local_shipping, color: kNavy, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo transporte'.toUpperCase(),
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      GlowDropdownFormField2<String>(
                        value: vehicleSelected.toString(),
                        textColor: Colors.black,
                        items: [
                          DropdownMenuItem(
                            enabled: false,
                            value: '0',
                            child: Text(
                              'Seleccione una opción',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ...catalogVehicles.map(
                            (c) => DropdownMenuItem(
                              value: c.idVehicleType.toString(),
                              child: Text(
                                c.name,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (id) {
                          if (id != null) {
                            onVehicleChanged(int.parse(id));
                          }
                        },
                        validator: (v) {
                          if (v == '0' || v == null || v.trim().isEmpty) {
                            return messageValidatorEmpty;
                          }
                          return null;
                        },
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _LogisticaFila extends StatelessWidget {
  final IconData icono;
  final String label;
  final String valor;

  const _LogisticaFila({required this.icono, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kGrayBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: kNavy, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 3),
                // Text(valor,
                //     style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500)),

                TextFormField(
                  controller: _truckLicenseCtrl,
                  validator: (v) {
                    if (v == null || v.isEmpty) return messageValidatorEmpty;
                    return null;
                  },
                )
                
              ],
            ),
          ),
        ],
      ),
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
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onCrear,
          style: ElevatedButton.styleFrom(
            backgroundColor: kNavy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}