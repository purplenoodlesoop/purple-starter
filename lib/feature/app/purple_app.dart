import 'package:flutter/material.dart';
import 'package:purple_starter/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/feature/settings/controller/theme_controller.dart';
import 'package:purple_starter/feature/settings/widget/theme_controller_provider.dart';

class PurpleApp extends StatelessWidget {
  const PurpleApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ThemeControllerProvider(
        themeController: ThemeController(),
        child: const AppConfiguration(),
      );
}
