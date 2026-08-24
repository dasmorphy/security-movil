import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


Future<bool> hasInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Normaliza las imágenes a `List<Uint8List>` para guardarlas dentro del
/// propio registro de Hive.
///
/// Antes las imágenes se escribían a disco y en Hive se almacenaba solo la
/// ruta ABSOLUTA del archivo. En iOS el path del contenedor de la app incluye
/// un UUID que cambia entre actualizaciones y relanzamientos, por lo que la
/// ruta dejaba de resolver tras horas/días y las imágenes se perdían
/// silenciosamente. Guardando los bytes en Hive el registro es autocontenido:
/// Hive re-resuelve su propia ruta en cada arranque, así que sobrevive a
/// relanzamientos, actualizaciones y cambios de contenedor.
Future<Map<String, dynamic>> _prepareDataForStorage(
  Map<String, dynamic> data,
) async {
  final preparedData = Map<String, dynamic>.from(data);

  if (preparedData['images'] is List) {
    preparedData['images'] = (preparedData['images'] as List)
        .whereType<Uint8List>()
        .toList(); // Bytes guardados directo en Hive
  }

  return preparedData;
}

Map<String, dynamic> restoreFiles(Map<String, dynamic> data) {
  final restored = Map<String, dynamic>.from(data);

  if (restored['images'] is List) {
    restored['images'] = (restored['images'] as List)
        .map<Uint8List>(
          (e) => e is Uint8List
              ? e
              // Hive puede devolver List<int> según el tipo almacenado
              : Uint8List.fromList((e as List).cast<int>()),
        )
        .toList();
  }

  return restored;
}


Future<void> savePendingRequest(Map<String, dynamic> data, String nameMethod) async {
  final box = Hive.box('pending_requests');
  final preparedData = await _prepareDataForStorage(data);

  await box.add({
    'endpoint': nameMethod,
    'payload': preparedData,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

Future<void> savePendingBiomar(Map<String, dynamic> data, String nameMethod) async {
  final box = Hive.box('pending_biomar');
  final preparedData = await _prepareDataForStorage(data);

  await box.add({
    'endpoint': nameMethod,
    'payload': preparedData,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

Future<void> savePendingEmployeeMovements(Map<String, dynamic> data) async {
  final box = Hive.box('pending_employee_movements');
  final preparedData = await _prepareDataForStorage(data);

  await box.add({
    'payload': preparedData,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

Future<void> savePendingRegisterTech(Map<String, dynamic> data) async {
  final box = Hive.box('register_technical');
  final preparedData = await _prepareDataForStorage(data);

  await box.add({
    'payload': preparedData,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

Future<void> savePendingUpdateTech(Map<String, dynamic> data) async {
  final box = Hive.box('update_technical');
  final preparedData = await _prepareDataForStorage(data);

  await box.add({
    'payload': preparedData,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

class SyncService {
  StreamSubscription? _sub;
  VoidCallback? _onSyncNeeded;

  void start({VoidCallback? onSyncNeeded}) {
    _onSyncNeeded = onSyncNeeded;
    
    _sub = Connectivity()
        .onConnectivityChanged
        .listen((result) async {
      if (result != ConnectivityResult.none) {
        if (await hasInternet()) {
          // Notificar que hay internet disponible para sincronizar
          _onSyncNeeded?.call();
        }
      }
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}


class AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback? onResume;
  
  AppLifecycleObserver({this.onResume});
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await hasInternet()) {
        // Sincronizar cuando el app vuelve a primer plano
        onResume?.call();
      }
    }
  }
}





