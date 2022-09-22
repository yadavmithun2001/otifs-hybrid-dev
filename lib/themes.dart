import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.jost().fontFamily,
      colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Color(0xff1C1C1E),
      colorScheme: ColorScheme.dark(),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff1C1C1E),
      ));
}
