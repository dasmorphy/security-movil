import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isReady = false;
  bool _flashEnabled = false;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // 1. Primero pedir permiso
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) Navigator.pop(context);
      return;
    }

    // 2. Obtener cámaras disponibles
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    // 3. Crear e inicializar el controller
    await _setupController(_cameras.first);
  }

  Future<void> _setupController(CameraDescription camera) async {
    // Disponer controller anterior si existe
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

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile photo = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, File(photo.path));
      }
    } catch (e) {
      debugPrint('Error al tomar foto: $e');
    }
  }

  Future<void> _toggleFlash() async {
    final newMode = _flashEnabled ? FlashMode.off : FlashMode.torch;
    await _controller?.setFlashMode(newMode);
    setState(() => _flashEnabled = !_flashEnabled);
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    setState(() => _isReady = false);

    final currentDirection = _controller!.description.lensDirection;
    final newCamera = _cameras.firstWhere(
      (c) => c.lensDirection != currentDirection,
      orElse: () => _cameras.first,
    );

    await _setupController(newCamera);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: 'Cámara'),
      ),
      body: GestureDetector(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Preview
            CameraPreview(_controller!),

            // Controles inferiores
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flash
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        _flashEnabled ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  // Botón captura
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 85,
                      height: 85,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Cambiar cámara
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: _cameras.length >= 2 ? _switchCamera : null,
                      icon: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
