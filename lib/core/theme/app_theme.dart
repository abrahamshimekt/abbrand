import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme =
      ThemeData(
    useMaterial3: true,

    colorSchemeSeed:
        Colors.indigo,

    scaffoldBackgroundColor:
        const Color(
      0xFFF6F7FB,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
    ),
  );
}