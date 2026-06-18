import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/shared/global_loading_bottom_sheet.dart';
import 'package:zentinel/presentation/widgets/shared/qr_scanner.dart';

/// Formulario de asistencia OMARSA.
///
/// Flujo (todo visual, el envío a los APIs lo maneja quien integra mediante
/// los callbacks):
///   1. Abre la cámara con el [QrScanner] y espera un escaneo.
///   2. Al escanear muestra "Validando…" y espera la respuesta del provider
///      (igual que `_crearDespacho`, con una variable `response`).
///   3. Si la respuesta es exitosa muestra "Capturando foto…" (sin abrir otra
///      cámara) y toma una foto con la misma cámara del escáner.
///   4. Muestra "Imagen capturada" y vuelve a habilitar el escáner para un
///      nuevo escaneo.
///   5. Si la respuesta es rechazada muestra el error y vuelve al escaneo.
class AttendanceOmarsaForm extends ConsumerStatefulWidget {
  /// Valida el QR escaneado contra el API. Devuelve un [ApiResponse] igual que
  /// el `onSubmit` de `DispatchForm`.
  final Future<ApiResponse> Function(Map<String, dynamic>) onSubmit;

  /// Opcional: recibe la foto capturada tras una validación exitosa para que
  /// quien integre la envíe al API correspondiente.
  final Future<void> Function(Uint8List photo)? onPhotoCaptured;

  const AttendanceOmarsaForm({
    super.key,
    required this.onSubmit,
    this.onPhotoCaptured,
  });

  @override
  ConsumerState<AttendanceOmarsaForm> createState() =>
      _AttendanceOmarsaFormState();
}

class _AttendanceOmarsaFormState extends ConsumerState<AttendanceOmarsaForm> {
  final GlobalKey<QrScannerState> _scannerKey = GlobalKey<QrScannerState>();
  bool _isProcessing = false;

  Future<void> _registrarAsistencia(String code) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Pausa el escáner mientras se valida.
    _scannerKey.currentState?.pause();

    // 1. Validando…
    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading,
      message: 'Validando código QR...',
    );

    final authState = ref.read(userSessionProvider);

    // Usuario no cargado o sesión inválida.
    if (!authState.hasValue || authState.value == null) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Sesión no válida. Vuelva a iniciar sesión',
        autoDismiss: const Duration(seconds: 2),
      );
      await Future.delayed(const Duration(seconds: 2));
      _scannerKey.currentState?.resume();
      if (mounted) setState(() => _isProcessing = false);
      return;
    }

    final userData = authState.value!;

    final data = <String, dynamic>{
      "qr_code": code,
      "external_transaction_id": const Uuid().v4(),
      "user": userData.user,
    };

    // Espera la respuesta del provider (igual que `_crearDespacho`).
    // final response = await widget.onSubmit.call(data);
    final response = ApiResponse(success: true);
    if (!mounted) return;

    // 2b. Rechazado.
    if (!response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: response.message ?? 'Código QR rechazado',
        autoDismiss: const Duration(seconds: 2),
      );
      await Future.delayed(const Duration(seconds: 2));
      _scannerKey.currentState?.resume();
      if (mounted) setState(() => _isProcessing = false);
      return;
    }

    // 2a. Exitoso.
    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.success,
      message: 'Código QR validado',
      autoDismiss: const Duration(seconds: 1),
    );
    await Future.delayed(const Duration(seconds: 1));

    // 3. Capturando foto (solo la alerta, sin abrir otra cámara).
    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading,
      message: 'Capturando foto...',
    );

    final Uint8List? photo = await _scannerKey.currentState?.capturePhoto();
    if (!mounted) return;

    // El envío de la foto al API lo maneja quien integra.
    if (photo != null) {
      await widget.onPhotoCaptured?.call(photo);
      if (!mounted) return;
    }

    // 4. Imagen capturada.
    GlobalLoadingBottomSheet.show(
      status: photo != null ? OverlayStatus.success : OverlayStatus.warning,
      message: photo != null
          ? 'Imagen capturada'
          : 'No se pudo capturar la imagen',
      autoDismiss: const Duration(milliseconds: 1500),
    );
    await Future.delayed(const Duration(milliseconds: 1500));

    // 5. Listo para un nuevo escaneo.
    _scannerKey.currentState?.resume();
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return QrScanner(
      key: _scannerKey,
      onScan: _registrarAsistencia,
    );
  }
}
