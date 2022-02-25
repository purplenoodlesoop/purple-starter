import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/common/extension/extensions.dart';
import 'package:purple_starter/feature/settings/bloc/settings_bloc.dart';
import 'package:purple_starter/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/feature/settings/repository/settings_repository.dart';

extension on BuildContext {
  SettingsBloc get bloc => read<SettingsBloc>();

  T selectState<T>(
    T Function(SettingsState state) selector,
  ) =>
      select<SettingsBloc, T>(
        (bloc) => selector(bloc.state),
      );
}

class SettingsScope extends StatelessWidget {
  final Widget child;

  const SettingsScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  // --- Data --- //

  static ThemeMode _mapStateToThemeMode(
    SettingsState state,
  ) =>
      state.data.theme.pipe((theme) => theme ?? AppTheme.system).when(
            light: () => ThemeMode.light,
            dark: () => ThemeMode.dark,
            system: () => ThemeMode.system,
          );

  /// Listens by default
  static ThemeMode themeModeOf(
    BuildContext context,
  ) =>
      context.selectState(_mapStateToThemeMode);

  // --- Methods --- //

  static void setTheme(
    BuildContext context,
    AppTheme theme,
  ) =>
      context.bloc.add(
        SettingsEvent.setTheme(theme: theme),
      );

  // --- Build --- //

  @override
  Widget build(BuildContext context) => BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(
          settingsRepository: SettingsRepository(
            settingsDao: SettingsDao(context.sharedPreferences),
          ),
        ),
        child: child,
      );
}
