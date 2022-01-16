import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/app_configuration.dart';
import 'package:functional_starter/features/settings/controller/theme_controller.dart';
import 'package:functional_starter/features/settings/widgets/theme_controller_provider.dart';

class NameAppPage extends StatelessWidget {
  const NameAppPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ThemeControllerProvider(
        themeController: ThemeController(),
        child: const AppConfiguration(),
      );
}
