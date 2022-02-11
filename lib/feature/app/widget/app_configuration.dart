import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:functional_starter/feature/settings/widget/theme_controller_provider.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    Key? key,
  }) : super(key: key);

  ThemeData _listenTheme(BuildContext context) =>
      ThemeControllerProvider.maybeOf(context, listen: true)?.theme ??
      ThemeData.light();

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: _listenTheme(context),
      );
}
