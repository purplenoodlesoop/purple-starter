import 'package:flutter/material.dart';
import 'package:flutter_arbor/flutter_arbor.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/gen/l10n/app_localizations.g.dart';

extension BuildContextX on BuildContext {
  AppDependencies get _appDependencies => NodeScope.of<AppDependencies>(
        this,
        listen: true,
      );

  CoreDependencies get coreDependencies => _appDependencies.core;
  FeatureDependencies get featureDependencies => _appDependencies.feature;
  Logger get logger => coreDependencies.logger;

  AppLocalizations get localized => AppLocalizations.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
