import 'package:flutter/material.dart';

/// Paleta semántica de la app. Los widgets deben pedir el color por su
/// función (`context.colors.card`, `context.colors.textPrimary`, ...) y no por
/// su valor, para que cambie automáticamente entre modo claro y oscuro.
///
/// Los valores de [AppColors.dark] son exactamente los que la app usaba antes
/// de tener temas, para que el modo oscuro se vea igual que siempre.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Marca
  final Color primary; // Botones principales, acentos de marca
  final Color primaryDisabled;
  final Color primaryStrong; // Texto/íconos de marca sobre fondo de la app
  final Color primarySoft; // Fondos suaves con tinte de marca (chips, badges)
  final Color focus; // Borde de inputs con foco
  final Color secondary; // Variante más oscura del verde (botones secundarios)
  final Color onPrimary; // Texto sobre botones de marca

  // Superficies
  final Color background; // Fondo de pantallas (Scaffold)
  final Color card; // Tarjetas, formularios, modales
  final Color surfaceAlt; // Bloques dentro de tarjetas (encabezados, resúmenes)
  final Color fieldFill; // Relleno de inputs y dropdowns
  final Color border; // Borde sutil (inputs, divisores)
  final Color borderStrong; // Borde visible (tarjetas destacadas)

  // Texto
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary; // Etiquetas pequeñas, placeholders
  final Color icon;

  // Estados
  final Color success;
  final Color warning;
  final Color error;
  final Color info; // Enlaces y acciones de texto
  final Color highlight; // Datos destacados (ej. nombre del cliente)

  // Navegación y overlays
  final Color navBar; // Barra de navegación inferior
  final Color navActive; // Ítem activo de la barra inferior
  final Color navInactive; // Ítem inactivo de la barra inferior
  final Color overlayPanel; // Panel de diálogos/overlays de estado
  final Color sheet; // Fondo de modales inferiores y buscador
  final Color neutralButton; // Botones secundarios grises (Cerrar, Volver)

  const AppColors({
    required this.primary,
    required this.primaryDisabled,
    required this.primaryStrong,
    required this.primarySoft,
    required this.focus,
    required this.secondary,
    required this.onPrimary,
    required this.background,
    required this.card,
    required this.surfaceAlt,
    required this.fieldFill,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.icon,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.highlight,
    required this.navBar,
    required this.navActive,
    required this.navInactive,
    required this.overlayPanel,
    required this.sheet,
    required this.neutralButton,
  });

  static const dark = AppColors(
    primary: Color.fromARGB(189, 7, 213, 213),
    primaryDisabled: Color.fromARGB(120, 7, 213, 213),
    primaryStrong: Color.fromARGB(255, 7, 213, 213),
    primarySoft: Color.fromARGB(255, 18, 54, 42),
    focus: Color.fromARGB(190, 58, 199, 199),
    secondary: Color.fromARGB(189, 21, 139, 139),
    onPrimary: Colors.white,
    background: Color.fromARGB(255, 11, 16, 20),
    card: Color.fromARGB(255, 23, 24, 28),
    surfaceAlt: Color.fromARGB(255, 30, 30, 35),
    fieldFill: Color.fromARGB(255, 20, 21, 23),
    border: Colors.white12,
    borderStrong: Color.fromARGB(255, 75, 83, 83),
    textPrimary: Colors.white,
    textSecondary: Color.fromARGB(255, 180, 180, 180),
    textTertiary: Color.fromARGB(255, 150, 150, 150),
    icon: Colors.white,
    success: Color.fromARGB(255, 34, 197, 94),
    warning: Color.fromARGB(255, 255, 152, 0),
    error: Color.fromARGB(255, 185, 28, 16),
    info: Color.fromARGB(255, 137, 172, 255),
    highlight: Color.fromARGB(255, 76, 195, 233),
    navBar: Color.fromARGB(255, 34, 33, 33),
    navActive: Color.fromARGB(255, 4, 229, 221),
    navInactive: Colors.white70,
    overlayPanel: Color(0xFF2A2A2A),
    sheet: Color(0xFF1E1E1E),
    neutralButton: Color(0xFF444444),
  );

  /// Modo claro: fondo blanco con un tinte muy leve del verde de la marca.
  /// El verde se oscurece un poco para que el texto blanco de los botones
  /// tenga contraste suficiente sobre él.
  static const light = AppColors(
    primary: Color(0xFF00A6A6),
    primaryDisabled: Color(0x6600A6A6),
    primaryStrong: Color(0xFF007C7C),
    primarySoft: Color(0xFFDDF5F3),
    focus: Color(0xFF14B3B3),
    secondary: Color(0xFF0F7F7F),
    onPrimary: Colors.white,
    background: Color(0xFFF2F7F7),
    card: Colors.white,
    surfaceAlt: Color(0xFFEDF4F4),
    fieldFill: Color(0xFFF6FAFA),
    border: Color(0xFFDCE6E6),
    borderStrong: Color(0xFFB7C7C7),
    textPrimary: Color(0xFF14202B),
    textSecondary: Color(0xFF4A5858),
    textTertiary: Color(0xFF6E7C7C),
    icon: Color(0xFF2E3B3B),
    success: Color(0xFF16A34A),
    warning: Color(0xFFE68A00),
    error: Color(0xFFC62828),
    info: Color(0xFF2F5BD3),
    highlight: Color(0xFF0E8FB8),
    navBar: Colors.white,
    navActive: Color(0xFF009A9A),
    navInactive: Color(0xFF7A8888),
    overlayPanel: Colors.white,
    sheet: Colors.white,
    neutralButton: Color(0xFFE3EBEB),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDisabled,
    Color? primaryStrong,
    Color? primarySoft,
    Color? focus,
    Color? secondary,
    Color? onPrimary,
    Color? background,
    Color? card,
    Color? surfaceAlt,
    Color? fieldFill,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? icon,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? highlight,
    Color? navBar,
    Color? navActive,
    Color? navInactive,
    Color? overlayPanel,
    Color? sheet,
    Color? neutralButton,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      primarySoft: primarySoft ?? this.primarySoft,
      focus: focus ?? this.focus,
      secondary: secondary ?? this.secondary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      card: card ?? this.card,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      fieldFill: fieldFill ?? this.fieldFill,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      icon: icon ?? this.icon,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      highlight: highlight ?? this.highlight,
      navBar: navBar ?? this.navBar,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      overlayPanel: overlayPanel ?? this.overlayPanel,
      sheet: sheet ?? this.sheet,
      neutralButton: neutralButton ?? this.neutralButton,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: l(primary, other.primary),
      primaryDisabled: l(primaryDisabled, other.primaryDisabled),
      primaryStrong: l(primaryStrong, other.primaryStrong),
      primarySoft: l(primarySoft, other.primarySoft),
      focus: l(focus, other.focus),
      secondary: l(secondary, other.secondary),
      onPrimary: l(onPrimary, other.onPrimary),
      background: l(background, other.background),
      card: l(card, other.card),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      fieldFill: l(fieldFill, other.fieldFill),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      icon: l(icon, other.icon),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      error: l(error, other.error),
      info: l(info, other.info),
      highlight: l(highlight, other.highlight),
      navBar: l(navBar, other.navBar),
      navActive: l(navActive, other.navActive),
      navInactive: l(navInactive, other.navInactive),
      overlayPanel: l(overlayPanel, other.overlayPanel),
      sheet: l(sheet, other.sheet),
      neutralButton: l(neutralButton, other.neutralButton),
    );
  }
}

extension AppColorsContext on BuildContext {
  /// Paleta del tema activo. Si por algún motivo no está registrada, se usa
  /// la oscura para conservar el aspecto original.
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.dark;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
