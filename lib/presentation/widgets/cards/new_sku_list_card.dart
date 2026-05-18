import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/dispatch_products.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NewSkuListCard extends StatefulWidget {
  final List<SkuItem> skus;
  final void Function(int) onDeleteSku;
  final VoidCallback onAddSku;
  final void Function(int skuIndex) onAgregarProducto;
  final void Function(int skuIndex, bool isChecked)? onSkuCheckedChanged;

  const NewSkuListCard({
    super.key,
    required this.skus,
    required this.onAddSku,
    required this.onDeleteSku,
    required this.onAgregarProducto,
    this.onSkuCheckedChanged,
  });

  @override
  State<NewSkuListCard> createState() => _NewSkuListCardState();
}

class _NewSkuListCardState extends State<NewSkuListCard> {
  late Map<int, bool> _skuCheckedStates;

  @override
  void initState() {
    super.initState();
    _initializeSkuStates();
  }

  void _initializeSkuStates() {
    _skuCheckedStates = {};
    for (int i = 0; i < widget.skus.length; i++) {
      _skuCheckedStates[i] = false;
    }
  }

  @override
  void didUpdateWidget(NewSkuListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skus.length != widget.skus.length) {
      _initializeSkuStates();
    }
  }

  void _onSkuToggled(int skuIndex, bool value) {
    setState(() {
      _skuCheckedStates[skuIndex] = value;
    });
    widget.onSkuCheckedChanged?.call(skuIndex, value);
  }

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
                _AgregarSkuBtn(onTap: widget.onAddSku),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
        ...List.generate(
          widget.skus.length,
          (skuIndex) => _SkuCard(
            skuIndex: skuIndex,
            sku: widget.skus[skuIndex],
            canDelete: widget.skus.length > 1,
            isChecked: _skuCheckedStates[skuIndex] ?? false,
            onSkuCheckedChanged: (value) => _onSkuToggled(skuIndex, value),
            onDeleteSku: () => widget.onDeleteSku(skuIndex),
            onAgregarProducto: () => widget.onAgregarProducto(skuIndex),
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
  final bool canDelete;
  final bool isChecked;
  final ValueChanged<bool> onSkuCheckedChanged;
  final VoidCallback onDeleteSku;
  final VoidCallback onAgregarProducto;

  const _SkuCard({
    required this.skuIndex,
    required this.sku,
    required this.canDelete,
    required this.isChecked,
    required this.onSkuCheckedChanged,
    required this.onDeleteSku,
    required this.onAgregarProducto,
  });

  String get _status {
    return isChecked || (sku.productos.where((p) => p.productoId != null).length > 1) 
        ? 'multiple' 
        : 'individual';
  }

  Color _getStatusColor() {
    return (isChecked || (sku.productos.where((p) => p.productoId != null).length > 1))
        ? const Color.fromARGB(255, 245, 158, 11)
        : const Color.fromARGB(255, 34, 197, 94);
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
              // Badges y botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (canDelete)
                    GestureDetector(
                      onTap: onDeleteSku,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12,),
              // Header del SKU con Toggle
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SKU ${(skuIndex + 1).toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Toggle similar a FinishMaterialItemCard
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildSkuToggle(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkuToggle() {
    return GestureDetector(
      onTap: () {
        onSkuCheckedChanged(!isChecked);
      },
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isChecked
              ? const Color.fromARGB(255, 34, 197, 94)
              : const Color.fromARGB(255, 75, 83, 83),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isChecked ? 24 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
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
