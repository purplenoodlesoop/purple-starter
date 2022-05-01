enum AppTheme {
  light,
  dark,
  system,
}

extension AppThemeX on AppTheme {
  static AppTheme fromString(String source) => AppTheme.values.byName(source);

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
