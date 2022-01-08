import 'package:flutter/material.dart';
import 'package:functional_starter/features/settings/widgets/theme_controller_provider.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    Key? key,
  }) : super(key: key);

  ThemeData _listenTheme(BuildContext context) =>
      ThemeControllerProvider.maybeOf(context, listen: true)?.theme ??
      ThemeData.light();

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: _listenTheme(context),
      );
}
