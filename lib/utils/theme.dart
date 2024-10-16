// lib/utils/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalTheme {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromRGBO(225, 195, 64, 1),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(225, 195, 64, 1),
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.kanit(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.kanit(
        fontSize: 20,
        color: Colors.black87,
      ),
      bodyLarge: GoogleFonts.kanit(
        fontSize: 16,
        color: Colors.black54,
      ),
      titleLarge: GoogleFonts.kanit(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(225, 195, 64, 1),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromRGBO(225, 195, 64, 1),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromRGBO(225, 195, 64, 1),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(225, 195, 64, 1),
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.kanit(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.kanit(
        fontSize: 20,
        color: Colors.white70,
      ),
      bodyLarge: GoogleFonts.kanit(
        fontSize: 16,
        color: Colors.white60,
      ),
      titleLarge: GoogleFonts.kanit(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(225, 195, 64, 1),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromRGBO(225, 195, 64, 1),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
