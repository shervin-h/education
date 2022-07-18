import 'package:flutter/material.dart';

class ThemeInfo extends ChangeNotifier {

  /////// Brightness section///////
  bool _darkTheme = true;

  bool get isDark {
    return _darkTheme;
  }

  void setDarkTheme(bool darkMode) {
    _darkTheme = darkMode;
    notifyListeners();
  }

  void changeBrightness() {
    _darkTheme = !_darkTheme;
    notifyListeners();
  }
  /////// End Brightness section ///////


  /////// Font section ///////
  String _fontFamily = 'BYekan';

  String get fontFamily {
    return _fontFamily;
  }

  void setFontFamily(String fontFamily) {
    _fontFamily = fontFamily;
    notifyListeners();
  }
  /////// End Font section ///////


}