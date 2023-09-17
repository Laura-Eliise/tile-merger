import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../static/theme.dart';

class CostumeText extends Text {
  CostumeText(
    String text, {
    super.key,
    double size = 50,
    FontWeight weight = FontWeight.bold,
  }) : super(text,
            style: TextStyle(
                color: darkTextColor,
                fontSize: size,
                fontWeight: weight,
                fontFamily: GoogleFonts.openSans().fontFamily));
}
