import 'package:flutter/material.dart';
import 'package:purple_starter/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/feature/settings/widget/scope/settings_scope.dart';

class PurpleStarterApp extends StatelessWidget {
  const PurpleStarterApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SettingsScope(
        child: AppConfiguration(),
      );
}
