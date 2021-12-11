import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/app_configuration.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';
import 'package:functional_starter/features/settings/classes/theme_controller.dart';
import 'package:functional_starter/features/settings/widgets/theme_controller_provider.dart';

class NameApp extends StatelessWidget {
  const NameApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ThemeControllerProvider(
        themeController: ThemeController(),
        child: const AppDependenciesProvider(
          child: AppConfiguration(),
        ),
      );
}
