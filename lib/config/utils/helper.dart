import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/domain/entities/user_session.dart';

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

String formatDate(String isoDate) {
  final date = DateTime.parse(isoDate);
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
          'Por favor, ve a Ajustes para habilitarlo.'
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