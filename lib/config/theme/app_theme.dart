import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: const Color.fromARGB(255, 40, 98, 245),
    textTheme: GoogleFonts.montserratTextTheme()
  );
}