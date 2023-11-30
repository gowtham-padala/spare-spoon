import 'package:flutter/material.dart';

// Class to for the theme provider.
// This class is used to switch between light and dark themes.
class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  void setDarkTheme(bool value) {
    _darkTheme = value;
    notifyListeners();
  }
}
