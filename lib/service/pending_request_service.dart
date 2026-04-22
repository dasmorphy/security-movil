import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';


Future<bool> hasInternet() async {
  try {
    return await InternetConnection().hasInternetAccess;
  } catch (_) {
    return false;
  }
}

Future<List<String>> saveImagesToDisk(List<Uint8List> images) async {
  final dir = await getApplicationDocumentsDirectory();
  List<String> paths = [];

  for (int i = 0; i < images.length; i++) {
    final file = File('${dir.path}/img_${DateTime.now().millisecondsSinceEpoch}_$i.webp');
    await file.writeAsBytes(images[i]);
    paths.add(file.path);
  }

  return paths;
}

/// Convierte archivos a Base64 para poder ser guardados en Hive
Future<Map<String, dynamic>> _prepareDataForStorage(
  Map<String, dynamic> data,
) async {
  final preparedData = Map<String, dynamic>.from(data);

  if (preparedData['images'] != null && preparedData['images'] is List) {
    preparedData['images'] = await saveImagesToDisk(
      (preparedData['images'] as List).whereType<Uint8List>().toList(),
    );
    // Ahora 'images' es List<String> de paths
  }

  return preparedData;
}

Map<String, dynamic> restoreFiles(Map<String, dynamic> data) {
  final restored = Map<String, dynamic>.from(data);

  if (restored['images'] != null && restored['images'] is List) {
    restored['images'] = (restored['images'] as List)
        .whereType<String>()
        .where((path) => File(path).existsSync())
        .map((path) => File(path).readAsBytesSync()) // path → Uint8List
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





