import 'package:purple_starter/src/core/error/parsing_exception.dart';

enum AppTheme {
  light,
  dark,
  system,
}

extension AppThemeX on AppTheme {
  static AppTheme fromString(String source) {
    const values = {
      'light': AppTheme.light,
      'dark': AppTheme.dark,
      'system': AppTheme.system,
    };

    final parsed = values[source];
    if (parsed != null) return parsed;
    throw ParsingException<String, AppTheme>(source);
  }

  R when<R>({
    required R Function() light,
    required R Function() dark,
    required R Function() system,
  }) {
    switch (this) {
      case AppTheme.light:
        return light();
      case AppTheme.dark:
        return dark();
      case AppTheme.system:
        return system();
    }
  }
}
