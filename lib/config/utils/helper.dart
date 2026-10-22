import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

int getUnityIdByCategory({
  required String nameCategory,
  required List<UnityWeight> unities,
}) {
  // regla de negocio
  if (nameCategory == 'Materiales') {
    final unity = unities.firstWhere(
      (u) => u.name == 'UNIDAD',
      orElse: () => throw Exception('Unidad "UNIDAD" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Suministros') {
    final unity = unities.firstWhere(
      (u) => u.name == 'UNIDAD',
      orElse: () => throw Exception('Unidad "UNIDAD" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Repuestos') {
    final unity = unities.firstWhere(
      (u) => u.name == 'UNIDAD',
      orElse: () => throw Exception('Unidad "UNIDAD" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Balanceado') {
    final unity = unities.firstWhere(
      (u) => u.name == 'SACOS',
      orElse: () => throw Exception('Unidad "SACOS" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Larvas') {
    final unity = unities.firstWhere(
      (u) => u.name == 'UNIDAD',
      orElse: () => throw Exception('Unidad "UNIDAD" no encontrada'),
    );
    return unity.idUnity;
  }
  if (nameCategory == 'Maquinaria') {
    final unity = unities.firstWhere(
      (u) => u.name == 'UNIDAD',
      orElse: () => throw Exception('Unidad "UNIDAD" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Combustibles /lubricantes') {
    final unity = unities.firstWhere(
      (u) => u.name == 'GALONES',
      orElse: () => throw Exception('Unidad "GALONES" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Otros') {
    final unity = unities.firstWhere(
      (u) => u.name == 'BINES',
      orElse: () => throw Exception('Unidad "BINES" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Camarón') {
    final unity = unities.firstWhere(
      (u) => u.name == 'LIBRAS',
      orElse: () => throw Exception('Unidad "LIBRAS" no encontrada'),
    );
    return unity.idUnity;
  }

  if (nameCategory == 'Tilapia') {
    final unity = unities.firstWhere(
      (u) => u.name == 'LIBRAS',
      orElse: () => throw Exception('Unidad "LIBRAS" no encontrada'),
    );
    return unity.idUnity;
  }

  // fallback o regla por defecto
  final defaultUnity = unities.firstWhere(
    (u) => u.name == 'LIBRAS',
    orElse: () => throw Exception('Unidad por defecto no encontrada'),
  );

  return defaultUnity.idUnity;
}

Options noMessages() =>
    Options(extra: {'showErrorMessage': false, 'showSuccessMessage': false});

Options onlyError() =>
    Options(extra: {'showErrorMessage': true, 'showSuccessMessage': false});

Options successAndError() =>
    Options(extra: {'showErrorMessage': true, 'showSuccessMessage': true});

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

String formatDateDetails(String dateString) {
  try {
    final normalized = dateString.replaceFirst(' ', 'T');
    final date = DateTime.parse(normalized);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  } catch (_) {
    return dateString; // fallback seguro
  }
}

extension UserPermissions on User {
  bool hasPermission(String permission) {
    return attributes['permissions']?.contains(permission) ?? false;
  }

  bool hasAny(List<String> permissions) {
    final userPerms = attributes['permissions'] as List<dynamic>? ?? [];
    return permissions.any(userPerms.contains);
  }

  bool hasAll(List<String> permissions) {
    final userPerms = attributes['permissions'] as List<dynamic>? ?? [];
    return permissions.every(userPerms.contains);
  }
}

MediaType getMediaType(String path) {
  final extension = path.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'png':
      return MediaType('image', 'png');
    case 'gif':
      return MediaType('image', 'gif');
    case 'webp':
      return MediaType('image', 'webp');
    default:
      return MediaType('image', 'jpeg');
  }
}

Future<bool> requestCameraPermission(BuildContext context) async {
  var status = await Permission.camera.status;

  // Si ya está concedido, retorna true
  if (status.isGranted) {
    return true;
  }

  // Si está permanentemente denegado, guía al usuario
  if (status.isPermanentlyDenied) {
    final result = await showDialog<bool>(
      context: context, // Necesitarás pasar el context como parámetro
      builder: (context) => AlertDialog(
        title: const Text('Permiso de cámara requerido'),
        content: const Text(
          'El acceso a la cámara está deshabilitado. '
          'Por favor, ve a Ajustes para habilitarlo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context, true);
            },
            child: const Text('Abrir Ajustes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Solicita el permiso
  status = await Permission.camera.request();
  print('Estado del permiso: $status');
  return status.isGranted;
}

Map<String, dynamic> mapPendingToUI(Map<String, dynamic> raw) {
  final bool processing = raw['processing'] == true;

  return {
    "name": raw['endpoint'] == 'logbook_entry'
        ? 'Bitácora entrada'
        : 'Bitácora salida',
    "subtitle": raw['payload']['shipping_guide'] ?? 'Desconocido',
    "statusText": processing ? 'Subiendo...' : 'Pendiente',
  };
}

Map<String, dynamic> mapPendingBiomar(Map<String, dynamic> raw) {
  final bool processing = raw['processing'] == true;

  return {
    "name": raw['endpoint'] == 'entry'
        ? 'Registro entrada'
        : 'Despacho',
    "subtitle": raw['payload']['dni'] ?? raw['payload']['order_number'] ?? 'Desconocido',
    "statusText": processing ? 'Subiendo...' : 'Pendiente',
  };
}

Map<String, dynamic> mapPendingEmployeeMovements(Map<String, dynamic> raw) {
  final bool processing = raw['processing'] == true;
  const movementStatus = {
    'CHECK_IN': 'Ingreso',
    'TRANSFER': 'Movimiento interno',
    'CHECK_OUT': 'Salida',
  };

  final typeMovement = movementStatus[raw['payload']['type_movement']] ?? 'Desconocido';
  return {
    "name": 'Movimiento',
    "subtitle": typeMovement,
    "statusText": processing ? 'Subiendo...' : 'Pendiente',
  };
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

Future<Uint8List?> convertToWebP(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    format: CompressFormat.webp,
    quality: 60,
    minWidth: 800,   // mínimo
    minHeight: 800,
    // No uses minWidth como si fuera maxWidth
  );
  // Eliminar el archivo temporal de cámara inmediatamente
  // después de todo
  await Future.delayed(const Duration(seconds: 1));
  await file.delete();
  return result; // retorna Uint8List directamente
}

Future<Position?> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Verificar si el GPS está activo
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Verificar permisos
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // Obtener ubicación actual
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

/// Los colores de estado están pensados para modo oscuro (fondo oscuro con
/// texto brillante). En modo claro se cambian por su equivalente: fondo
/// pastel con texto oscuro de la misma familia.
const Map<int, Color> _statusLightEquivalent = {
  // Textos
  0xFFF8AC46: Color(0xFFB45309), // ámbar
  0xFF89ACFF: Color(0xFF1D4ED8), // azul
  0xFF69F6B8: Color(0xFF047857), // verde
  0xFFF66969: Color(0xFFB91C1C), // rojo
  0xFFFFFFFF: Color(0xFF374151), // neutro
  // Fondos
  0xFF3D2B0E: Color(0xFFFEF3C7), // ámbar
  0xFF222C3F: Color(0xFFDBEAFE), // azul
  0xFF12362A: Color(0xFFD1FAE5), // verde
  0xFF361212: Color(0xFFFEE2E2), // rojo
  0xFF525453: Color(0xFFE5E7EB), // neutro
};

Color adaptStatusColor(Color color, {bool isDark = true}) {
  if (isDark) return color;
  return _statusLightEquivalent[color.value] ?? color;
}

Color getStatusColorDispatch(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorDispatch(status), isDark: isDark);

Color getStatusColorBckgDispatch(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorBckgDispatch(status), isDark: isDark);

Color getStatusColorEntryAccess(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorEntryAccess(status), isDark: isDark);

Color getStatusColorBckgEntry(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorBckgEntry(status), isDark: isDark);

Color getStatusColorEmployees(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorEmployees(status), isDark: isDark);

Color getColorTxtEmployees(String status, {bool isDark = true}) =>
    adaptStatusColor(_getColorTxtEmployees(status), isDark: isDark);

Color getColorTxtMovements(String status, {bool isDark = true}) =>
    adaptStatusColor(_getColorTxtMovements(status), isDark: isDark);

Color getStatusColorMovements(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorMovements(status), isDark: isDark);

Color getColorTxtOrder(String status, {bool isDark = true}) =>
    adaptStatusColor(_getColorTxtOrder(status), isDark: isDark);

Color getStatusColorOrder(String status, {bool isDark = true}) =>
    adaptStatusColor(_getStatusColorOrder(status), isDark: isDark);

Color _getStatusColorDispatch(String status) {
  switch (status.toLowerCase()) {
    case 'en tránsito':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'salida de planta':
      return const Color.fromARGB(255, 137, 172, 255);
    case 'ingresado en bodega':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color _getStatusColorBckgDispatch(String status) {
  switch (status.toLowerCase()) {
    case 'en tránsito':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'salida de planta':
      return const Color.fromARGB(255, 34, 44, 63);
    case 'ingresado en bodega':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

Color _getStatusColorEntryAccess(String status) {
  switch (status.toLowerCase()) {
    case 'pendiente salida':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'finalizado':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color _getStatusColorBckgEntry(String status) {
  switch (status.toLowerCase()) {
    case 'pendiente salida':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'finalizado':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

Color _getStatusColorEmployees(String status) {
  switch (status.toLowerCase()) {
    case 'no autorizado':
      return const Color.fromARGB(255, 54, 18, 18);
    case 'autorizado':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

Color _getColorTxtEmployees(String status) {
  switch (status.toLowerCase()) {
    case 'no autorizado':
      return const Color.fromARGB(255, 246, 105, 105);
    case 'autorizado':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color _getColorTxtMovements(String status) {
  switch (status.toLowerCase()) {
    case 'salida':
      return const Color.fromARGB(255, 246, 105, 105);
    case 'movimiento interno':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'ingreso':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return const Color.fromARGB(255, 255, 255, 255);
  }
}

Color _getStatusColorMovements(String status) {
  switch (status.toLowerCase()) {
    case 'salida':
      return const Color.fromARGB(255, 54, 18, 18);
    case 'movimiento interno':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'ingreso':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return const Color.fromARGB(255, 82, 84, 83);
  }
}

Color _getColorTxtOrder(String status) {
  switch (status.toLowerCase()) {
    case 'con novedad':
      return const Color.fromARGB(255, 246, 105, 105);
    case 'incompleto':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'completado':
      return const Color.fromARGB(255, 105, 246, 184);
    case 'programado':
      return const Color.fromARGB(255, 137, 172, 255);
    default:
      return const Color.fromARGB(255, 255, 255, 255);
  }
}

Color _getStatusColorOrder(String status) {
  switch (status.toLowerCase()) {
    case 'con novedad':
      return const Color.fromARGB(255, 54, 18, 18);
    case 'incompleto':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'completado':
      return const Color.fromARGB(255, 18, 54, 42);
    case 'programado':
      return const Color.fromARGB(255, 34, 44, 63);
    default:
      return const Color.fromARGB(255, 82, 84, 83);
  }
}

String formatDateToApi(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}
