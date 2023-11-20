import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  void setDarkTheme(bool value) {
    _darkTheme = value;
    notifyListeners();
  }
}
