import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/widget/bloc_scope.dart';
import 'package:purple_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';

AppTheme _theme(SettingsState state) => state.data.theme;

ThemeMode _themeToThemeMode(AppTheme theme) => theme.when(
      light: () => ThemeMode.light,
      dark: () => ThemeMode.dark,
      system: () => ThemeMode.system,
    );

class SettingsScope extends StatelessWidget {
  final Widget child;

  const SettingsScope({
    required this.child,
    super.key,
  });

  static const BlocScope<SettingsEvent, SettingsState, SettingsBloc> _scope =
      BlocScope();

  /* --- Data --- */

  static ScopeData<ThemeMode> get themeModeOf =>
      _themeToThemeMode.dot(_theme).pipe(_scope.select);

  static ScopeData<AppTheme> get appThemeOf => _scope.select(_theme);

  /* --- Methods --- */
  void seTheme(BuildContext context, AppTheme theme) {
    _scope.add(context, SettingsEvent.setTheme(theme: theme));
  }

  /* --- Build --- */

  @override
  Widget build(BuildContext context) => BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(
          context.featureDependencies.settings,
        ),
        child: child,
      );
}
