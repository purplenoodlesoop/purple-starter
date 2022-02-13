enum AppTheme {
  light,
  dark,
}

extension AppThemeWhenX on AppTheme {
  R when<R>({
    required R Function() light,
    required R Function() dark,
  }) {
    switch (this) {
      case AppTheme.light:
        return light();
      case AppTheme.dark:
        return dark();
    }
  }
}
