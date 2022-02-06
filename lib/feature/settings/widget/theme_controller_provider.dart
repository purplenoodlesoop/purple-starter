import 'package:flutter/material.dart';
import 'package:functional_starter/common/extension/extensions.dart';
import 'package:functional_starter/feature/settings/controller/theme_controller.dart';

class ThemeControllerProvider extends InheritedNotifier<IThemeController> {
  const ThemeControllerProvider({
    Key? key,
    required IThemeController themeController,
    required Widget child,
  }) : super(
          key: key,
          notifier: themeController,
          child: child,
        );

  static IThemeController? maybeOf(
    BuildContext context, {
    bool listen = false,
  }) =>
      context
          .getInheritedWidget<ThemeControllerProvider>(listen: listen)
          ?.notifier;
}
