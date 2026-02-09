import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


Future<bool> hasInternet() async {
  try {
    return await InternetConnection().hasInternetAccess;
  } catch (_) {
    return false;
  }
}

/// Convierte archivos a Base64 para poder ser guardados en Hive
Future<Map<String, dynamic>> _prepareDataForStorage(
  Map<String, dynamic> data,
) async {
  final preparedData = Map<String, dynamic>.from(data);

  if (preparedData['images'] != null && preparedData['images'] is List) {
    preparedData['images'] = (preparedData['images'] as List)
      .whereType<File>()
      .map((file) => file.path)
      .toList();
  }

  return preparedData;
}

Map<String, dynamic> restoreFiles(Map<String, dynamic> data) {
  final restored = Map<String, dynamic>.from(data);

  if (restored['images'] != null && restored['images'] is List) {
    restored['images'] = (restored['images'] as List)
        .whereType<String>()
        .map((path) => File(path))
        .where((file) => file.existsSync())
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





