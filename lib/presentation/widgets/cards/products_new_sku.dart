import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/forms/dispatch.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ProductsNewSku extends StatelessWidget {
  final dynamic productos;
  final String tipoSku;
  final bool esMultiple;
  final void Function(int, String) onCantidadChanged;
  final void Function(int) onEliminar;
  final VoidCallback onAgregarProducto;

  const ProductsNewSku({
    super.key, 
    required this.productos,
    required this.tipoSku,
    required this.esMultiple,
    required this.onCantidadChanged,
    required this.onEliminar,
    required this.onAgregarProducto,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DETALLE DE CARGA',
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: esMultiple ? kNavyLight : kGreenLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tipoSku,
                    style: TextStyle(
                      color: esMultiple ? kNavy : kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...List.generate(productos.length, (i) => _ProductoRow(
                  index: i,
                  item: productos[i],
                  onCantidadChanged: (val) => onCantidadChanged(i, val),
                  onEliminar: productos.length > 1 ? () => onEliminar(i) : null,
                )),
                const SizedBox(height: 8),
                _AgregarProductoBtn(onTap: onAgregarProducto),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductoRow extends StatelessWidget {
  final int index;
  final ProductoItem item;
  final void Function(String) onCantidadChanged;
  final VoidCallback? onEliminar;

  const _ProductoRow({
    required this.index,
    required this.item,
    required this.onCantidadChanged,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PRODUCTO ${(index + 1).toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: kNavy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (onEliminar != null)
                GestureDetector(
                  onTap: onEliminar,
                  child: const Icon(Icons.close_rounded, size: 16, color: kTextHint),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: 
                // _DropdownProducto(
                //   valorActual: item.productoId,
                //   onChanged: (id) {
                //     item.productoId = id;
                //   },
                // ),

                GlowDropdownFormField2<String>(
                  value: item.productoId ?? '0',
                  textColor: Colors.black,
                  items: [
                    DropdownMenuItem(
                      enabled: false,
                      value: '0',
                      child: Text(
                        'Seleccione una opción',
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    ...catalogoProductos.map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          c.nombre,
                          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (id) {
                    if (id != null) {
                      item.productoId = id;
                    }
                  },
                  validator: (v) {
                    if (v == '0' || v == null || v.trim().isEmpty) {
                      return messageValidatorEmpty;
                    }
                    return null;
                  },
                ),


              ),
              const SizedBox(width: 8),
              // SizedBox(
              //   width: 64,
              //   child: _CantidadInput(
              //     valor: item.cantidad,
              //     onChanged: onCantidadChanged,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}


class _AgregarProductoBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AgregarProductoBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: kGrayBorder, width: 1.2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: kTextSecondary, size: 18),
            SizedBox(width: 6),
            Text(
              'AÑADIR PRODUCTO',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}