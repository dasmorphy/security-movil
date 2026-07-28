import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/technical/auditing_colors.dart';

/// Controlador de una firma manuscrita.
/// Guarda los trazos en coordenadas locales del lienzo y permite exportarlos
/// a PNG (Uint8List) sin depender de paquetes externos.
class SignaturePadController extends ChangeNotifier {
  final List<List<Offset>> _strokes = [];
  Size _canvasSize = Size.zero;

  List<List<Offset>> get strokes => _strokes;
  Size get canvasSize => _canvasSize;

  bool get isEmpty => _strokes.every((stroke) => stroke.isEmpty);
  bool get isNotEmpty => !isEmpty;

  void updateCanvasSize(Size size) => _canvasSize = size;

  void startStroke(Offset point) {
    _strokes.add([point]);
    notifyListeners();
  }

  void addPoint(Offset point) {
    if (_strokes.isEmpty) {
      _strokes.add([point]);
    } else {
      _strokes.last.add(point);
    }
    notifyListeners();
  }

  void clear() {
    if (_strokes.isEmpty) return;
    _strokes.clear();
    notifyListeners();
  }

  /// Devuelve la firma como PNG. `null` si no se dibujó nada.
  Future<Uint8List?> toPngBytes({
    Color strokeColor = Colors.black,
    Color background = Colors.white,
    double strokeWidth = 3,
    double pixelRatio = 2.0,
  }) async {
    if (isEmpty || _canvasSize.isEmpty) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.scale(pixelRatio);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, _canvasSize.width, _canvasSize.height),
      Paint()..color = background,
    );
    paintStrokes(canvas, _strokes, strokeColor, strokeWidth);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (_canvasSize.width * pixelRatio).round(),
      (_canvasSize.height * pixelRatio).round(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();

    return data?.buffer.asUint8List();
  }
}

/// Dibuja los trazos tanto en pantalla como al exportar la imagen.
void paintStrokes(
  Canvas canvas,
  List<List<Offset>> strokes,
  Color color,
  double strokeWidth,
) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  for (final stroke in strokes) {
    if (stroke.isEmpty) continue;

    if (stroke.length == 1) {
      canvas.drawCircle(stroke.first, strokeWidth / 2, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
      continue;
    }

    final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
    for (var i = 1; i < stroke.length; i++) {
      path.lineTo(stroke[i].dx, stroke[i].dy);
    }
    canvas.drawPath(path, paint);
  }
}

class SignaturePad extends StatefulWidget {
  final String label;
  final SignaturePadController controller;
  final double height;
  final bool hasError;

  const SignaturePad({
    super.key,
    required this.label,
    required this.controller,
    this.height = 170,
    this.hasError = false,
  });

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, _) {
        final isEmpty = widget.controller.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.label.toUpperCase(),
                    style: const TextStyle(
                      color: kAuditTextMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (!isEmpty)
                  TextButton.icon(
                    onPressed: widget.controller.clear,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 15, color: kAuditAccentSoft),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(
                        color: kAuditAccentSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: kAuditField,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.hasError && isEmpty ? kAuditDanger : kAuditBorder,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    widget.controller.updateCanvasSize(size);

                    return RawGestureDetector(
                      behavior: HitTestBehavior.opaque,
                      gestures: {
                        // Reconocedor "ansioso": gana la disputa frente al scroll
                        // para poder dibujar dentro de una lista desplazable.
                        _EagerPanRecognizer:
                            GestureRecognizerFactoryWithHandlers<_EagerPanRecognizer>(
                          () => _EagerPanRecognizer(),
                          (recognizer) {
                            recognizer
                              ..onStart = (details) {
                                FocusScope.of(context).unfocus();
                                widget.controller.startStroke(details.localPosition);
                              }
                              ..onUpdate = (details) {
                                final p = details.localPosition;
                                if (p.dx < 0 ||
                                    p.dy < 0 ||
                                    p.dx > size.width ||
                                    p.dy > size.height) {
                                  return;
                                }
                                widget.controller.addPoint(p);
                              };
                          },
                        ),
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SignaturePainter(widget.controller.strokes),
                            ),
                          ),
                          if (isEmpty)
                            const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.draw_outlined, color: kAuditTextMuted, size: 22),
                                  SizedBox(height: 6),
                                  Text(
                                    'Firme aquí',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (widget.hasError && isEmpty) ...[
              const SizedBox(height: 6),
              const Text(
                'La firma es obligatoria',
                style: TextStyle(color: kAuditDanger, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    paintStrokes(canvas, strokes, Colors.white, 2.5);
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}

/// PanGestureRecognizer que acepta el gesto de inmediato, evitando que el
/// scroll vertical del formulario se robe el trazo de la firma.
class _EagerPanRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}
