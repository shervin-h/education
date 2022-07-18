import 'package:flutter/material.dart';

Color materialGrey = const Color(0xFF2B2B2B);
Color lightMaterialGrey = const Color(0xFFE0E0E0);
Color backgroundColor = const Color.fromARGB(255, 20, 20, 20);

TextTheme setPreferredTextTheme(bool isDark, String fontFamily) {
  return isDark
      ? TextTheme(
          // Extremely large text.
          headline1: TextStyle(
            fontSize: 80.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Very, very large text.
          // Used for the date in the dialog shown by showDatePicker.
          headline2: TextStyle(
            fontSize: 64.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Very large text.
          headline3: TextStyle(
            fontSize: 48.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Large text.
          headline4: TextStyle(
            fontSize: 32.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Used for large text in dialogs (e.g., the month and year in the dialog shown by showDatePicker).
          headline5: TextStyle(
            fontSize: 24.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Used for the primary text in app bars and dialogs (e.g., AppBar.title and AlertDialog.title).
          headline6: TextStyle(
            fontSize: 16.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // Used for emphasizing text that would otherwise be bodyText2.
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 3,
              ),
            ],
          ),

          // The default text style for Material.
          bodyText2: TextStyle(
            fontSize: 13.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 2,
              ),
            ],
          ),

          // Used for the primary text in lists (e.g., ListTile.title).
          subtitle1: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 6,
              ),
            ],
          ),

          // For medium emphasis text that's a little smaller than subtitle1.
          subtitle2: TextStyle(
            fontSize: 13.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 4,
              ),
            ],
          ),

          // Used for auxiliary text associated with images.
          caption: TextStyle(
            fontSize: 12.5,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 2,
              ),
            ],
          ),

          // Used for text on ElevatedButton, TextButton and OutlinedButton.
          button: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 4,
              ),
            ],
          ),
        )
      : TextTheme(
          // Extremely large text.
          headline1: TextStyle(
            fontSize: 80.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Very, very large text.
          // Used for the date in the dialog shown by showDatePicker.
          headline2: TextStyle(
            fontSize: 64.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Very large text.
          headline3: TextStyle(
            fontSize: 48.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Large text.
          headline4: TextStyle(
            fontSize: 32.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Used for large text in dialogs (e.g., the month and year in the dialog shown by showDatePicker).
          headline5: TextStyle(
            fontSize: 24.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Used for the primary text in app bars and dialogs (e.g., AppBar.title and AlertDialog.title).
          headline6: TextStyle(
            fontSize: 16.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),

          // Used for emphasizing text that would otherwise be bodyText2.
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // The default text style for Material.
          bodyText2: TextStyle(
            fontSize: 13.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Used for the primary text in lists (e.g., ListTile.title).
          subtitle1: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // For medium emphasis text that's a little smaller than subtitle1.
          subtitle2: TextStyle(
            fontSize: 13.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Used for auxiliary text associated with images.
          caption: TextStyle(
            fontSize: 12.5,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade800,
          ),

          // Used for text on ElevatedButton, TextButton and OutlinedButton.
          button: TextStyle(
            fontSize: 14.0,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        );
}

ThemeData setPreferredThemeData(bool isDark, String fontFamily) {
  return isDark
      ? ThemeData.dark().copyWith(
          // The background color for major parts of the app (toolbars, tab bars, etc)
          // The theme's colorScheme property contains ColorScheme.primary, as well as a color that contrasts well with the primary color called ColorScheme.onPrimary. It might be simpler to just configure an app's visuals in terms of the theme's colorScheme.
          primaryColor: const Color(0xFF18FFFF),

          // A darker version of the primaryColor.
          primaryColorDark: const Color(0xFF00CBCC),

          // A lighter version of the primaryColor.
          primaryColorLight: const Color(0xFF76FFFF),

          // A set of twelve colors that can be used to configure the color properties of most components.
          // This property was added much later than the theme's set of highly specific colors, like cardColor, buttonColor, canvasColor etc. New components can be defined exclusively in terms of colorScheme. Existing components will gradually migrate to it, to the extent that is possible without significant backwards compatibility breaks.
          /*colorScheme: const ColorScheme(
            brightness: Brightness.dark,

            primary: Color(0xFF18FFFF),
            onPrimary: Color.fromARGB(255, 20, 20, 20),

            secondary: Color(0xFF9E9E9E),
            onSecondary: Colors.white,

            error: Colors.redAccent,
            onError: Colors.white,

            background: Color.fromARGB(255, 20, 20, 20),
            onBackground: Colors.white,

            surface: Color.fromARGB(255, 20, 20, 20),
            onSurface: Colors.white),*/

          // A color that contrasts with the primaryColor, e.g. used as the remaining part of a progress bar.
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),

          // The color of Dividers and PopupMenuDividers, also used between ListTiles, between rows in DataTables, and so forth.
          // To create an appropriate BorderSide that uses this color, consider Divider.createBorderSide.
          dividerColor: materialGrey.withOpacity(0.85),

          // The color of ink splashes.
          // splashColor: const Color(0xFF18FFFF),

          // The default color of the Material that underlies the Scaffold. The background color for a typical material app or a page within the app.
          scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),

          errorColor: Colors.redAccent,

          // An icon theme that contrasts with the primary color.
          primaryIconTheme: const IconThemeData(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),

          // A theme for customizing the color, elevation, brightness, iconTheme and textTheme of AppBars.
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF757575).withOpacity(0.2),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // A text theme that contrasts with the primary color.
          primaryTextTheme: setPreferredTextTheme(isDark, fontFamily),

          // Text with a color that contrasts with the card and canvas colors.
          textTheme: setPreferredTextTheme(isDark, fontFamily),
        )
      : ThemeData.light().copyWith(
          // The background color for major parts of the app (toolbars, tab bars, etc)
          // The theme's colorScheme property contains ColorScheme.primary, as well as a color that contrasts well with the primary color called ColorScheme.onPrimary. It might be simpler to just configure an app's visuals in terms of the theme's colorScheme.
          primaryColor: const Color(0xFF18FFFF),

          // A darker version of the primaryColor.
          primaryColorDark: const Color(0xFF00CBCC),

          // A lighter version of the primaryColor.
          primaryColorLight: const Color(0xFF76FFFF),

          // A set of twelve colors that can be used to configure the color properties of most components.
          // This property was added much later than the theme's set of highly specific colors, like cardColor, buttonColor, canvasColor etc. New components can be defined exclusively in terms of colorScheme. Existing components will gradually migrate to it, to the extent that is possible without significant backwards compatibility breaks.
          /*colorScheme: const ColorScheme(
            brightness: Brightness.dark,

            primary: Color(0xFF18FFFF),
            onPrimary: Color.fromARGB(255, 20, 20, 20),

            secondary: Color(0xFF9E9E9E),
            onSecondary: Colors.white,

            error: Colors.redAccent,
            onError: Colors.white,

            background: Colors.white,
            onBackground: Color.fromARGB(255, 20, 20, 20),

            surface: Colors.white,
            onSurface: Color.fromARGB(255, 20, 20, 20)),*/

          // A color that contrasts with the primaryColor, e.g. used as the remaining part of a progress bar.
          backgroundColor: Colors.white,

          // The color of Dividers and PopupMenuDividers, also used between ListTiles, between rows in DataTables, and so forth.
          // To create an appropriate BorderSide that uses this color, consider Divider.createBorderSide.
          dividerColor: Colors.grey[500],

          // The color of ink splashes.
          // splashColor: const Color(0xFF18FFFF),

          // The default color of the Material that underlies the Scaffold. The background color for a typical material app or a page within the app.
          scaffoldBackgroundColor: Colors.white,

          errorColor: Colors.redAccent,

          // An icon theme that contrasts with the primary color.
          primaryIconTheme: IconThemeData(color: Colors.grey.shade800),
          iconTheme: IconThemeData(color: Colors.grey.shade800),

          // A theme for customizing the color, elevation, brightness, iconTheme and textTheme of AppBars.
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // A text theme that contrasts with the primary color.
          primaryTextTheme: setPreferredTextTheme(isDark, fontFamily),

          // Text with a color that contrasts with the card and canvas colors.
          textTheme: setPreferredTextTheme(isDark, fontFamily),
        );
}

