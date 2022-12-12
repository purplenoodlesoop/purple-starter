import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/gen/l10n/app_localizations.g.dart';
import 'package:purple_starter/src/core/router/app_router.dart';
import 'package:purple_starter/src/feature/app/widget/app_router_builder.dart';
import 'package:purple_starter/src/feature/settings/widget/scope/settings_scope.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = SettingsScope.themeModeOf(context, listen: true);

    return AppRouterBuilder(
      createRouter: (context) => AppRouter(),
      builder: (context, parser, delegate) => MaterialApp.router(
        routeInformationParser: parser,
        routerDelegate: delegate,
        onGenerateTitle: (context) => context.localized.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
      ),
    );
  }
}
