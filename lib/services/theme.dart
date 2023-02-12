import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xff244248);
Color secondaryColor = const Color(0xff0c2d35).withOpacity(.47);
const Color backgroundDark = Color(0xff231F20);
const Color backgroundLight = Color(0xffffffff);

Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static Color textPrimary = const Color(0xff000000);
  static Color textSecondary = const Color(0xff838383);
  static ThemeData dark = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[200],
    // primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    backgroundColor: backgroundLight,
    cardColor: const Color(0xFFFFFFFF),
    primaryColor: primaryColor,
    dividerColor: const Color(0xFF2A2A2A),
    errorColor: const Color(0xFFCF6679),
    primaryColorDark: Colors.black,

    iconTheme: IconThemeData(color: Colors.grey[500]),
    primaryIconTheme: IconThemeData(color: Colors.grey[500]),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      titleTextStyle: GoogleFonts.montserrat(),
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
      ),
      displayLarge: GoogleFonts.montserrat(),
      displayMedium: GoogleFonts.montserrat(),
      displaySmall: GoogleFonts.montserrat(),
      headlineMedium: GoogleFonts.montserrat(),
      headlineSmall: GoogleFonts.montserrat(),
      titleLarge: GoogleFonts.montserrat(),
    ),
  );
}
