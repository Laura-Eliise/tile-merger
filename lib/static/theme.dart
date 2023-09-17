import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<int, Color> tileColors = <int, Color>{
  -1: Colors.black,
  0: Color(0xFFD8CCBD),
  2: Color(0xFFEEE4DA),
  4: Color(0xFFEDE0C8),
  8: Color(0xFFF2B179),
  16: Color(0xFFF59563),
  32: Color(0xFFF67C5F),
  64: Color(0xFFF65E3B),
  128: Color(0xFFEDCF72),
  256: Color(0xFFEDCC61),
  512: Color(0xFFEDC850),
  1024: Color(0xFFEDC53F),
  2048: Color(0xFFEDC22E),
    4096: Color.fromARGB(255, 200, 226, 5), 
  8192: Color.fromARGB(255, 174, 255, 0), 
  16384: Color.fromARGB(255, 104, 224, 0),
  32768: Color.fromARGB(255, 36, 238, 0), 
  65536: Color.fromARGB(255, 2, 205, 56), 
};

const Color darkBackgroundColor = Color(0xFFbbaaa0);
const Color lightBackgroundColor = Color(0xFFfbf8ef);
const Color darkTextColor = Color(0xFF766F65);
const Color lightTextColor = Color(0xFFFCFBFB);
const Color buttonColor = Color(0xFF8F7B64);



ThemeData getTheme(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
  );
}
