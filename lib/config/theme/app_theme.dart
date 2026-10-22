import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zentinel/config/theme/app_colors.dart';

export 'package:zentinel/config/theme/app_colors.dart';

class AppTheme {
  ThemeData lightTheme() => _build(AppColors.light, Brightness.light);

  ThemeData darkTheme() => _build(AppColors.dark, Brightness.dark);

  ThemeData _build(AppColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: c.primaryStrong,
      brightness: brightness,
    ).copyWith(
      primary: c.primaryStrong,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      surface: c.card,
      onSurface: c.textPrimary,
      error: c.error,
      outline: c.borderStrong,
      outlineVariant: c.border,
    );

    final baseText = GoogleFonts.montserratTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);

    final fieldRadius = BorderRadius.circular(8);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.card,
      cardColor: c.card,
      dividerColor: c.border,
      textTheme: baseText,
      iconTheme: IconThemeData(color: c.icon),
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.fieldFill,
        hintStyle: TextStyle(color: c.textTertiary),
        labelStyle: TextStyle(color: c.textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: c.focus),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: c.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.primaryDisabled,
          shape: RoundedRectangleBorder(borderRadius: fieldRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          side: BorderSide(color: c.borderStrong),
          shape: RoundedRectangleBorder(borderRadius: fieldRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.primaryStrong),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primaryStrong),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        modalBackgroundColor: c.card,
      ),
      dialogTheme: DialogThemeData(backgroundColor: c.card),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? c.surfaceAlt : c.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primary : null,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primaryStrong : null,
        ),
      ),
    );
  }
}
