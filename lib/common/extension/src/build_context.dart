import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.g.dart';
import 'package:purple_starter/common/database/app_database.dart';
import 'package:purple_starter/common/widget/app_dependencies_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BuildContextX on BuildContext {
  IAppDependencies get dependencies =>
      AppDependenciesScope.dependenciesOf(this);
  Dio get dio => dependencies.dio;
  AppDatabase get database => dependencies.database;
  SharedPreferences get sharedPreferences => dependencies.sharedPreferences;

  // ignore: avoid-non-null-assertion
  AppLocalizations get localized => AppLocalizations.of(this)!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
