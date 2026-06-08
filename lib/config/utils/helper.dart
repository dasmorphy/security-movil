import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/domain/entities/user_session.dart';
import 'package:path/path.dart' as p;
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

Color getStatusColorDispatch(String status) {
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

Color getStatusColorBckgDispatch(String status) {
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

Color getStatusColorEntryAccess(String status) {
  switch (status.toLowerCase()) {
    case 'pendiente salida':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'finalizado':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color getStatusColorBckgEntry(String status) {
  switch (status.toLowerCase()) {
    case 'pendiente salida':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'finalizado':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

Color getStatusColorEmployees(String status) {
  switch (status.toLowerCase()) {
    case 'no autorizado':
      return const Color.fromARGB(255, 54, 18, 18);
    case 'autorizado':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

Color getColorTxtEmployees(String status) {
  switch (status.toLowerCase()) {
    case 'no autorizado':
      return const Color.fromARGB(255, 246, 105, 105);
    case 'autorizado':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color getColorTxtMovements(String status) {
  switch (status.toLowerCase()) {
    case 'salida':
      return const Color.fromARGB(255, 246, 105, 105);
    case 'movimiento interno':
      return const Color.fromARGB(255, 248, 172, 70);
    case 'ingreso':
      return const Color.fromARGB(255, 105, 246, 184);
    default:
      return Colors.grey;
  }
}

Color getStatusColorMovements(String status) {
  switch (status.toLowerCase()) {
    case 'salida':
      return const Color.fromARGB(255, 54, 18, 18);
    case 'movimiento interno':
      return const Color.fromARGB(255, 61, 43, 14);
    case 'ingreso':
      return const Color.fromARGB(255, 18, 54, 42);
    default:
      return Colors.grey;
  }
}

String formatDateToApi(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}
