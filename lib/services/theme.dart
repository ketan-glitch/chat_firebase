import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xFF941f37);
Color secondaryColor = const Color(0xFF941f37).withOpacity(.47);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff838383);
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
  static ThemeData dark = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[200],
    primarySwatch: colorCustom,
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

    // iconTheme: IconThemeData(color: Colors.grey[500]),
    // primaryIconTheme: IconThemeData(color: Colors.grey[500]),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      actionsIconTheme: IconThemeData(
        color: primaryColor,
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      button: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),

      // titleLarge: ,
      // titleMedium: ,
      // titleSmall: ,
      subtitle1: const TextStyle(
        // fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      bodyText1: GoogleFonts.montserrat(
        // fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
      bodyText2: GoogleFonts.montserrat(
        // fontSize: 12.0,
        fontWeight: FontWeight.w400,
      ),
      headline1: GoogleFonts.montserrat(),
      headline2: GoogleFonts.montserrat(),
      headline3: GoogleFonts.montserrat(),
      headline4: GoogleFonts.montserrat(),
      headline5: GoogleFonts.montserrat(),
      headline6: GoogleFonts.montserrat(),
    ),
  );
}
