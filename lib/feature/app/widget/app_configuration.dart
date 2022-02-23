import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:purple_starter/common/extension/extensions.dart';
import 'package:purple_starter/feature/app/router/app_routes.dart';
import 'package:purple_starter/feature/app/widget/app_router_builder.dart';
import 'package:purple_starter/feature/settings/widget/scope/settings_scope.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppRouterBuilder(
        createRouter: (context) => GoRouter(routes: appRoutes),
        builder: (context, parser, delegate) => MaterialApp.router(
          routeInformationParser: parser,
          routerDelegate: delegate,
          onGenerateTitle: (context) => context.localized.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: SettingsScope.themeModeOf(context),
        ),
      );
}
