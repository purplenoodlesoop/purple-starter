import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:functional_starter/features/settings/interfaces/theme_controller.dart';

class ThemeController extends ChangeNotifier implements IThemeController {
  @override
  bool isDark = ui.window.platformBrightness == ui.Brightness.dark;

  @override
  bool get isLight => !isDark;

  @override
  ThemeData get theme => isLight ? ThemeData.light() : ThemeData.dark();

  @override
  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
