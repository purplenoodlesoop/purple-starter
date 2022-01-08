import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class IThemeController implements Listenable {
  ThemeData get theme;
  bool get isDark;
  bool get isLight;
  void toggleTheme();
}
