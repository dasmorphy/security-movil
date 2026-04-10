import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NewSkuListCard extends StatelessWidget {
  final List<SkuItem> skus;
  final List<DispatchProducts> catalogProducts;
  final void Function(int skuIndex, int productoIndex, String value)
  onCantidadChanged;
  final void Function(int skuIndex, int productoIndex) onDeleteProduct;
  final void Function(int) onDeleteSku;
  final VoidCallback onAddSku;
  final void Function(int skuIndex) onAgregarProducto;

  const NewSkuListCard({
    super.key,
    required this.skus,
    required this.catalogProducts,
    required this.onCantidadChanged,
    required this.onDeleteProduct,
    required this.onAddSku,
    required this.onDeleteSku,
    required this.onAgregarProducto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'GESTIÓN SKUS',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            Row(
              children: [
                _AgregarSkuBtn(onTap: onAddSku),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
        ...List.generate(
          skus.length,
          (skuIndex) => _SkuCard(
            skuIndex: skuIndex,
            sku: skus[skuIndex],
            catalogProducts: catalogProducts,
            canDelete: skus.length > 1,
            onDeleteSku: () => onDeleteSku(skuIndex),
            onCantidadChanged: (productoIndex, value) =>
                onCantidadChanged(skuIndex, productoIndex, value),
            onDeleteProduct: (productoIndex) =>
                onDeleteProduct(skuIndex, productoIndex),
            onAgregarProducto: () => onAgregarProducto(skuIndex),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _SkuCard extends StatelessWidget {
  final int skuIndex;
  final SkuItem sku;
  final List<DispatchProducts> catalogProducts;
  final bool canDelete;
  final VoidCallback onDeleteSku;
  final void Function(int, String) onCantidadChanged;
  final void Function(int) onDeleteProduct;
  final VoidCallback onAgregarProducto;

  const _SkuCard({
    required this.skuIndex,
    required this.sku,
    required this.catalogProducts,
    required this.canDelete,
    required this.onDeleteSku,
    required this.onCantidadChanged,
    required this.onDeleteProduct,
    required this.onAgregarProducto,
  });

  String get _tipoSku {
    return sku.productos.length > 1 ? 'SKU Mixto' : 'SKU Independiente';
  }

  bool get _esMultiple {
    return sku.productos.where((p) => p.productoId != null).length > 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 30, 30, 35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del SKU
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SKU ${(skuIndex + 1).toString()}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _esMultiple ? kNavyLight : kGreenLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _tipoSku,
                            style: TextStyle(
                              color: _esMultiple ? kNavy : kGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (canDelete) ...[
                          const SizedBox(width: 7),
                          GestureDetector(
                            onTap: onDeleteSku,
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
              // Productos del SKU
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      sku.productos.length,
                      (productoIndex) => _ProductoRow(
                        catalogProducts: catalogProducts,
                        index: productoIndex,
                        item: sku.productos[productoIndex],
                        onCantidadChanged: (val) =>
                            onCantidadChanged(productoIndex, val),
                        onDeleteProduct: sku.productos.length > 1
                            ? () => onDeleteProduct(productoIndex)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AgregarProductoBtn(onTap: onAgregarProducto),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductoRow extends StatelessWidget {
  final int index;
  final ProductoItem item;
  final List<DispatchProducts> catalogProducts;
  final void Function(String) onCantidadChanged;
  final VoidCallback? onDeleteProduct;

  const _ProductoRow({
    required this.index,
    required this.item,
    required this.catalogProducts,
    required this.onCantidadChanged,
    this.onDeleteProduct,
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
                'PRODUCTO ${(index + 1).toString()}',
                style: TextStyle(
                  color: Color.fromARGB(255, 150, 150, 150),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (onDeleteProduct != null)
                GestureDetector(
                  onTap: onDeleteProduct,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: kTextHint,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GlowDropdownFormField2<String>(
                  value: item.productoId ?? '0',
                  textColor: const Color.fromARGB(255, 255, 255, 255),
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
                    ...catalogProducts.map(
                      (c) => DropdownMenuItem(
                        value: c.idProduct.toString(),
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
              SizedBox(
                width: 64,
                child: _CantidadInput(
                  valor: item.cantidad,
                  onChanged: onCantidadChanged,
                ),
              ),
            ],
          ),
        ],
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

class _AgregarProductoBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AgregarProductoBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add_rounded, color: kTextSecondary, size: 18),
            SizedBox(width: 2),
            Text(
              "Añadir Producto",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 137, 172, 255),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgregarSkuBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AgregarSkuBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: kTextSecondary, size: 18),
            SizedBox(width: 2),
            Text(
              "Añadir Sku",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 137, 172, 255),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
