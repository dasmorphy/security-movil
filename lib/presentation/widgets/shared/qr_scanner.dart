import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Escáner de QR visual basado en el paquete `camera` (la misma cámara que
/// maneja la app, igual que [CameraImagePicker]/`CameraScreen`).
///
/// Muestra el preview de la cámara con un recuadro central para que el usuario
/// sepa dónde colocar el código QR. Expone su estado público [QrScannerState]
/// para que el formulario padre pueda:
///   * [QrScannerState.pause]  → dejar de aceptar escaneos mientras se valida.
///   * [QrScannerState.resume] → habilitar un nuevo escaneo.
///   * [QrScannerState.capturePhoto] → tomar una foto con la MISMA cámara,
///     sin abrir otra pantalla (la alerta la cubre por encima).
class QrScanner extends StatefulWidget {
  /// Se dispara cuando se escanea un código. El [code] es el valor decodificado
  /// del QR (cableado por quien integre el decodificador real).
  final void Function(String code) onScan;

  /// Texto guía mostrado debajo del recuadro.
  final String instruction;

  const QrScanner({
    super.key,
    required this.onScan,
    this.instruction = 'Coloca el código QR dentro del recuadro',
  });

  @override
  State<QrScanner> createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  CameraController? _controller;
  bool _isReady = false;
  bool _flashEnabled = false;

  /// Cuando es `false` el escáner no acepta nuevos escaneos (está validando).
  bool _scanning = true;

  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // 1. Permiso de cámara
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) Navigator.maybePop(context);
      return;
    }

    // 2. Cámaras disponibles (preferimos la trasera para escanear)
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    final back = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );

    // 3. Inicializar controller
    await _setupController(back);
  }

  Future<void> _setupController(CameraDescription camera) async {
    await _controller?.dispose();

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _flashEnabled = false;

    if (mounted) setState(() => _isReady = true);
  }

  // ─── API pública para el formulario padre ─────────────────────────────────

  /// Detiene la aceptación de escaneos (mientras se valida).
  void pause() {
    if (!mounted) return;
    setState(() => _scanning = false);
  }

  /// Habilita un nuevo escaneo.
  void resume() {
    if (!mounted) return;
    setState(() => _scanning = true);
  }

  /// Toma una foto con la misma cámara, sin abrir otra pantalla.
  /// Devuelve los bytes de la imagen o `null` si falla.
  Future<Uint8List?> capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;
    if (controller.value.isTakingPicture) return null;

    try {
      final XFile photo = await controller.takePicture();
      return await photo.readAsBytes();
    } catch (e) {
      debugPrint('Error al capturar foto: $e');
      return null;
    }
  }

  // ─── Interacción interna ───────────────────────────────────────────────────

  void _onScanPressed() {
    if (!_scanning) return;
    // TODO: reemplazar con el valor real decodificado del QR cuando se
    // integre el decodificador. Por ahora el flujo es visual.
    widget.onScan('');
  }

  Future<void> _toggleFlash() async {
    final newMode = _flashEnabled ? FlashMode.off : FlashMode.torch;
    try {
      await _controller?.setFlashMode(newMode);
      if (mounted) setState(() => _flashEnabled = !_flashEnabled);
    } catch (e) {
      debugPrint('Error al cambiar el flash: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null || !_controller!.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    const double frameSize = 260;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Preview de la cámara
          CameraPreview(_controller!),

          // Recuadro guía + esquinas
          Center(
            child: SizedBox(
              width: frameSize,
              height: frameSize,
              child: CustomPaint(
                painter: _CornerFramePainter(
                  color: _scanning
                      ? const Color.fromARGB(255, 7, 213, 213)
                      : Colors.white54,
                ),
              ),
            ),
          ),

          // Texto guía
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: frameSize + 32),
              child: Text(
                widget.instruction,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(color: Colors.black87, blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),

          // Flash (arriba derecha)
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: _toggleFlash,
                  icon: Icon(
                    _flashEnabled ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          // Botón de escaneo (abajo)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _scanning ? _onScanPressed : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color.fromARGB(189, 7, 213, 213),
                  disabledBackgroundColor: const Color.fromARGB(120, 7, 213, 213),
                ),
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text(
                  'Escanear código',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dibuja únicamente las esquinas del recuadro guía del escáner.
class _CornerFramePainter extends CustomPainter {
  final Color color;
  const _CornerFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double corner = 28;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Superior izquierda
    canvas.drawLine(const Offset(0, 0), const Offset(corner, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, corner), paint);

    // Superior derecha
    canvas.drawLine(Offset(size.width - corner, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // Inferior izquierda
    canvas.drawLine(Offset(0, size.height - corner), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);

    // Inferior derecha
    canvas.drawLine(
        Offset(size.width, size.height - corner), Offset(size.width, size.height), paint);
    canvas.drawLine(
        Offset(size.width - corner, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_CornerFramePainter oldDelegate) => oldDelegate.color != color;
}
