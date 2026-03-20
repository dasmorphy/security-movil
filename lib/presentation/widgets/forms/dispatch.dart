import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────

class ProductoItem {
  String? productoId;
  int cantidad;
  ProductoItem({this.productoId, this.cantidad = 1});
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

final List<Conductor> conductores = [
  Conductor(id: 'c1', nombre: 'Carlos Mendoza', patente: 'FR-992'),
  Conductor(id: 'c2', nombre: 'Roberto Castillo', patente: 'BCDF-21'),
  Conductor(id: 'c3', nombre: 'Ana Fuentes', patente: 'GH-441'),
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

// InputDecoration styleDecoration() => InputDecoration(
//   filled: true,
//   fillColor: const Color.fromARGB(255, 20, 21, 23),
//   contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//   // border: OutlineInputBorder(
//   //   borderRadius: borderRadius,
//   //   borderSide: BorderSide(color: Colors.white12),
//   // ),
//   // focusedBorder: OutlineInputBorder(
//   //   borderRadius: borderRadius,
//   //   borderSide: BorderSide(color: Color.fromARGB(190, 58, 199, 199)),
//   // ),
// );

// ─── Screen principal ──────────────────────────────────────────────────────

class DispatchForm extends StatefulWidget {
  const DispatchForm({super.key});

  @override
  State<DispatchForm> createState() => _CrearDespachoScreenState();
}

class _CrearDespachoScreenState extends State<DispatchForm> {
  final List<ProductoItem> _productos = [
    ProductoItem(productoId: 'p1', cantidad: 12),
    ProductoItem(productoId: 'p2', cantidad: 4),
  ];

  Conductor? _conductorSeleccionado = conductores[0];
  final String _destino = 'Centro de Distribución Norte - Bodega';

  String get _tipoSku {
    final conProducto = _productos.where((p) => p.productoId != null).length;
    return conProducto > 1 ? 'SKU Múltiple' : 'SKU Independiente';
  }

  bool get _esMultiple {
    return _productos.where((p) => p.productoId != null).length > 1;
  }

  void _agregarProducto() {
    setState(() {
      _productos.add(ProductoItem());
    });
  }

  void _eliminarProducto(int index) {
    if (_productos.length <= 1) return;
    setState(() {
      _productos.removeAt(index);
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
                  _SKUModeSelector(),
                  const SizedBox(height: 16),
                  ProductsNewSku(
                    productos: _productos,
                    tipoSku: _tipoSku,
                    esMultiple: _esMultiple,
                    onCantidadChanged: _onCantidadChanged,
                    onEliminar: _eliminarProducto,
                    onAgregarProducto: _agregarProducto,
                  ),
                  const SizedBox(height: 16),
                  _InformacionLogisticaCard(
                    destino: _destino,
                    conductorSeleccionado: _conductorSeleccionado,
                    conductores: conductores,
                    onConductorChanged: (c) => setState(() => _conductorSeleccionado = c),
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

class _SKUModeSelector extends StatefulWidget {
  @override
  State<_SKUModeSelector> createState() => _SKUModeSelectorState();
}

class _SKUModeSelectorState extends State<_SKUModeSelector> {
  bool _modoNuevo = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ModeCard(
          icon: Icons.add,
          label: 'Agregar\nSKU',
          selected: _modoNuevo,
          onTap: () => setState(() => _modoNuevo = true),
        )),
        const SizedBox(width: 12),
        Expanded(child: _ModeCard(
          icon: Icons.playlist_add_check_rounded,
          label: 'Seleccionar\nExistente',
          selected: !_modoNuevo,
          onTap: () => setState(() => _modoNuevo = false),
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

class _CantidadInput extends StatefulWidget {
  final int valor;
  final void Function(String) onChanged;

  const _CantidadInput({required this.valor, required this.onChanged});

  @override
  State<_CantidadInput> createState() => _CantidadInputState();
}

class _CantidadInputState extends State<_CantidadInput> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.valor.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGrayBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGrayBorder, width: 0.5),
      ),
      child: TextField(
        controller: _ctrl,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: widget.onChanged,
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
            icono: Icons.location_on_rounded,
            label: 'DESTINO',
            valor: destino,
          ),
          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),
          _ConductorFila(
            conductorSeleccionado: conductorSeleccionado,
            conductores: conductores,
            onChanged: onConductorChanged,
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
                Text(valor,
                    style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConductorFila extends StatelessWidget {
  final Conductor? conductorSeleccionado;
  final List<Conductor> conductores;
  final void Function(Conductor?) onChanged;

  const _ConductorFila({
    required this.conductorSeleccionado,
    required this.conductores,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: const Icon(Icons.person_rounded, color: kNavy, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CONDUCTOR',
                    style: TextStyle(
                        color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 3),
                DropdownButtonHideUnderline(
                  child: DropdownButton<Conductor>(
                    value: conductorSeleccionado,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kTextSecondary, size: 18),
                    style: const TextStyle(
                        color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'sans-serif'),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    items: conductores.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.nombre} (Camión ${c.patente})'),
                    )).toList(),
                    onChanged: onChanged,
                  ),
                ),
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