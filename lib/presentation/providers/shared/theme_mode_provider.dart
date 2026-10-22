import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:zentinel/data/services/hive_service.dart';

/// Modo de tema elegido por el usuario: sistema (por defecto), claro u oscuro.
/// Se guarda en Hive para conservarlo entre reinicios.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeModeNotifier() : super(_read());

  static ThemeMode _read() {
    try {
      final saved = Hive.box(HiveService.settingsBox).get(_key) as String?;
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == saved,
        orElse: () => ThemeMode.system,
      );
    } catch (_) {
      return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await Hive.box(HiveService.settingsBox).put(_key, mode.name);
  }
}
