import 'package:flutter/material.dart';
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

// ─── Datos de ejemplo ──────────────────────────────────────────────────────

final List<ProductoCatalogo> catalogoProductos = [
  ProductoCatalogo(id: 'p1', nombre: 'Panel Solar XL-400'),
  ProductoCatalogo(id: 'p2', nombre: 'Inversor Trifásico'),
  ProductoCatalogo(id: 'p3', nombre: 'Batería 48V 200Ah'),
  ProductoCatalogo(id: 'p4', nombre: 'Cable Solar 6mm²'),
  ProductoCatalogo(id: 'p5', nombre: 'Estructura Aluminio'),
];

final List<Map<String, dynamic>> skuAvailable = [
  {'id': 1, 'nombre': 'SKU 001'},
  {'id': 2, 'nombre': 'SKU 002'},
  {'id': 3, 'nombre': 'SKU 003'},
  {'id': 4, 'nombre': 'SKU 004'},
  {'id': 5, 'nombre': 'SKU 005'},
];

final List<Conductor> conductores = [
  Conductor(id: 'c1', nombre: 'Centro', patente: 'FR-992'),
  Conductor(id: 'c2', nombre: 'Norte', patente: 'BCDF-21'),
  Conductor(id: 'c3', nombre: 'Sur', patente: 'GH-441'),
];

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

// ─── Screen principal ──────────────────────────────────────────────────────

class DispatchForm extends StatefulWidget {
  const DispatchForm({super.key});

  @override
  State<DispatchForm> createState() => _CrearDespachoScreenState();
}

class _CrearDespachoScreenState extends State<DispatchForm> {
  bool _modoNuevo = true;

  final List<ProductoItem> _productos = [
    ProductoItem(),
  ];

  final List<SkuItem> _skus = [
    SkuItem(),
  ];

  Conductor? _conductorSeleccionado = conductores[0];
  final String _destino = 'Centro de Distribución Norte - Bodega';

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

  void _crearDespacho() {
    final productosValidos = _productos.where((p) => p.productoId != null).toList();
    if (productosValidos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto al SKU')),
      );
      return;
    }
    if (_conductorSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un conductor')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Despacho creado · ${productosValidos.length} producto(s) · ${_conductorSeleccionado!.nombre}',
        ),
        backgroundColor: kNavy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SKUModeSelector(
                    modoNuevo: _modoNuevo,
                    onChanged: (val) => setState(() => _modoNuevo = val)
                  ),
                  const SizedBox(height: 16),
                  ProductsNewSku(
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
                    destino: _destino,
                    conductorSeleccionado: _conductorSeleccionado,
                    conductores: conductores,
                    onConductorChanged: (c) => setState(() => 
                      _conductorSeleccionado = c
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
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

class _SKUModeSelector extends StatelessWidget {
  final bool modoNuevo;
  final Function(bool) onChanged;

  const _SKUModeSelector({
    required this.modoNuevo, 
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ModeCard(
          icon: Icons.add,
          label: 'Agregar\nSKU',
          selected: modoNuevo,
          onTap: () => onChanged(true),
        )),
        const SizedBox(width: 12),
        Expanded(child: _ModeCard(
          icon: Icons.playlist_add_check_rounded,
          label: 'Seleccionar\nExistente',
          selected: !modoNuevo,
          onTap: () => onChanged(false),
        )),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? kNavy : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? kNavy : kGrayBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? Colors.white : kNavy, size: 26),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : kNavy,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ─── Información logística ─────────────────────────────────────────────────

class _InformacionLogisticaCard extends StatelessWidget {
  final String destino;
  final Conductor? conductorSeleccionado;
  final List<Conductor> conductores;
  final void Function(Conductor?) onConductorChanged;

  const _InformacionLogisticaCard({
    required this.destino,
    required this.conductorSeleccionado,
    required this.conductores,
    required this.onConductorChanged,
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
            valor: destino,
          ),
          
          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),
          CustomDropdownField<Conductor>(
            label: 'Destino',
            icon: Icons.location_on_rounded,
            value: conductorSeleccionado,
            items: conductores,
            itemLabel: (c) => '${c.nombre} (Camión ${c.patente})',
            onChanged: (c) => onConductorChanged,
          ),

          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),
          CustomDropdownField<Conductor>(
            label: 'Tipo transporte',
            icon: Icons.local_shipping,
            value: conductorSeleccionado,
            items: conductores,
            itemLabel: (c) => c.nombre,
            onChanged: (c) => onConductorChanged,
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
          onPressed: onCrear,
          style: ElevatedButton.styleFrom(
            backgroundColor: kNavy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Crear Despacho',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}