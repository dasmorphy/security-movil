import 'package:flutter/material.dart';

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
  late TextEditingController _commentaryCtrl;
  late FocusNode _commentaryFocus;

  @override
  void initState() {
    super.initState();
    _receivedQty = widget.receivedQty ?? 0;
    _commentaryCtrl = TextEditingController(text: widget.commentary ?? '');
    _commentaryFocus = FocusNode();
  }

  @override
  void dispose() {
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
            _buildReceivedQtySlider(),
            const SizedBox(height: 16),
          ],

          // Comentario/Novedad
          if (widget.hasDiscrepancy) ...[
            _buildCommentaryField(),
            const SizedBox(height: 16),
          ],

          // Botón adjuntar evidencia
          if (widget.hasDiscrepancy) ...[
            GestureDetector(
              onTap: () => widget.onPhotoPressed?.call(true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 40, 40, 45),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 75, 83, 83),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Color.fromARGB(255, 150, 150, 150),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Adjuntar Evidencia Fotográfica',
                      style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          color: widget.hasDiscrepancy
              ? const Color.fromARGB(255, 34, 197, 94)
              : const Color.fromARGB(255, 75, 83, 83),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: widget.hasDiscrepancy ? 24 : 2,
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

  Widget _buildReceivedQtySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CANTIDAD RECIBIDA',
          style: TextStyle(
            color: Color.fromARGB(255, 150, 150, 150),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 25, 25, 30),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromARGB(255, 75, 83, 83),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$_receivedQty',
                style: const TextStyle(
                  color: Color.fromARGB(255, 76, 195, 233),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    elevation: 0,
                  ),
                  activeTrackColor:
                      const Color.fromARGB(255, 76, 195, 233),
                  inactiveTrackColor:
                      const Color.fromARGB(255, 75, 83, 83),
                  thumbColor: const Color.fromARGB(255, 76, 195, 233),
                ),
                child: Slider(
                  value: _receivedQty.toDouble(),
                  min: 0,
                  max: widget.expectedQty.toDouble(),
                  divisions: widget.expectedQty,
                  onChanged: (newValue) {
                    setState(() {
                      _receivedQty = newValue.toInt();
                    });
                    widget.onReceivedQtyChanged?.call(_receivedQty);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentaryField() {
    final fieldFill = const Color.fromARGB(255, 25, 25, 30);
    final borderRadius = BorderRadius.circular(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COMENTARIO/NOVEDAD',
          style: TextStyle(
            color: Color.fromARGB(255, 150, 150, 150),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _commentaryFocus,
          builder: (_, __) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: _commentaryFocus.hasFocus
                    ? [
                        BoxShadow(
                          color: const Color.fromARGB(190, 58, 199, 199)
                              .withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: _commentaryCtrl,
                focusNode: _commentaryFocus,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                minLines: 3,
                onChanged: (value) {
                  widget.onCommentaryChanged?.call(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldFill,
                  hintText: 'Se recibe 1 unidad menos debido a...',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 75, 83, 83),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: const BorderSide(
                      color: Color.fromARGB(190, 58, 199, 199),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
