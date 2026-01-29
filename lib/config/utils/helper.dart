import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/unity_weight.dart';
import 'package:intl/intl.dart';

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

Options noMessages() => Options(
  extra: {'showErrorMessage': false, 'showSuccessMessage': false},
);

Options onlyError() => Options(
  extra: {'showErrorMessage': true, 'showSuccessMessage': false},
);

Options successAndError() => Options(
  extra: {'showErrorMessage': true, 'showSuccessMessage': true},
);


String formatDate(String isoDate) {
  final date = DateTime.parse(isoDate);
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

