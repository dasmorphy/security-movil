import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class ReceivedProductItem extends StatefulWidget {
  final String productName;
  final String status; // CORRECTO, DISCREPANCIA
  final int expectedQty;
  final int? receivedQty;
  final String? commentary;
  final bool hasDiscrepancy;
  final Function(int)? onReceivedQtyChanged;
  final Function(String)? onCommentaryChanged;
  final Function(bool)? onPhotoPressed;
  final ValueChanged<bool>? onToggleChanged;

  const ReceivedProductItem({
    super.key,
    required this.productName,
    required this.status,
    required this.expectedQty,
    this.receivedQty,
    this.commentary,
    this.hasDiscrepancy = false,
    this.onReceivedQtyChanged,
    this.onCommentaryChanged,
    this.onPhotoPressed,
    this.onToggleChanged,
  });

  @override
  State<ReceivedProductItem> createState() => _ReceivedProductItemState();
}

class _ReceivedProductItemState extends State<ReceivedProductItem> {
  late int _receivedQty;
  late TextEditingController _receivedQtyCtrl;
  late FocusNode _receivedQtyFocus;

  late TextEditingController _commentaryCtrl;
  late FocusNode _commentaryFocus;

  @override
  void initState() {
    super.initState();

    _receivedQty = widget.receivedQty ?? 0;

    _receivedQtyCtrl =
        TextEditingController(text: _receivedQty.toString());
    _receivedQtyFocus = FocusNode();

    _commentaryCtrl =
        TextEditingController(text: widget.commentary ?? '');
    _commentaryFocus = FocusNode();
  }

  @override
  void dispose() {
    _receivedQtyCtrl.dispose();
    _receivedQtyFocus.dispose();

    _commentaryCtrl.dispose();
    _commentaryFocus.dispose();

    super.dispose();
  }

  Color _getStatusColor() {
    if (widget.status == 'CORRECTO') {
      return const Color.fromARGB(255, 34, 197, 94);
    } else if (widget.status == 'DISCREPANCIA') {
      return const Color.fromARGB(255, 245, 158, 11);
    }
    return const Color.fromARGB(255, 150, 150, 150);
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 35),
        borderRadius: BorderRadius.circular(16),
        // border: Border(
        //   left: BorderSide(
        //     color: _getStatusColor(),
        //     width: 4,
        //   ),
        //   top: BorderSide(
        //     color: const Color.fromARGB(255, 75, 83, 83),
        //     width: 1,
        //   ),
        //   right: BorderSide(
        //     color: const Color.fromARGB(255, 75, 83, 83),
        //     width: 1,
        //   ),
        //   bottom: BorderSide(
        //     color: const Color.fromARGB(255, 75, 83, 83),
        //     width: 1,
        //   ),
        // ),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con producto y estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cantidad esperada: ${widget.expectedQty} unidades',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                      color: _getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildToggle(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cantidad recibida con slider
          if (widget.hasDiscrepancy) ...[
            CommentaryReception(
              label: 'CANTIDAD RECIBIDA',
              controller: _receivedQtyCtrl,
              focusNode: _receivedQtyFocus,
              hint: 'Observaciones generales sobre la recepción (opcional)',
              onChanged: (value) {
                final qty = int.tryParse(value);
                if (qty != null) {
                  setState(() {
                    _receivedQty = qty;
                  });
                  widget.onReceivedQtyChanged?.call(qty);
                }
              },
            ),
            const SizedBox(height: 16),
          ],

          // Comentario/Novedad
          if (widget.hasDiscrepancy) ...[
            CommentaryReception(
              controller: _commentaryCtrl,
              focusNode: _commentaryFocus,
              hint: 'Se recibe 1 unidad menos debido a...',
              onChanged: (value) {
                widget.onCommentaryChanged?.call(value);
              },
            ),
            const SizedBox(height: 16),
          ],

        ],
      ),
    );
  }

  Widget _buildToggle() {
    return GestureDetector(
      onTap: () {
        widget.onToggleChanged?.call(!widget.hasDiscrepancy);
      },
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: !widget.hasDiscrepancy
            ? const Color.fromARGB(255, 34, 197, 94)
            : const Color.fromARGB(255, 75, 83, 83),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: !widget.hasDiscrepancy ? 24 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
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
