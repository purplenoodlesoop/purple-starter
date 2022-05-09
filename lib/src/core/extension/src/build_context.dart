import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.g.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/core/model/dependencies_storage.dart';
import 'package:purple_starter/src/core/model/environment_storage.dart';
import 'package:purple_starter/src/core/model/repository_storage.dart';
import 'package:purple_starter/src/core/widget/dependencies_scope.dart';
import 'package:purple_starter/src/core/widget/environment_scope.dart';
import 'package:purple_starter/src/core/widget/repository_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BuildContextX on BuildContext {
  IEnvironmentStorage get environment => EnvironmentScope.of(this);
  IDependenciesStorage get dependencies => DependenciesScope.of(this);
  Dio get dio => dependencies.dio;
  AppDatabase get database => dependencies.database;
  SharedPreferences get sharedPreferences => dependencies.sharedPreferences;

  IRepositoryStorage get repository => RepositoryScope.of(this);

  // ignore: avoid-non-null-assertion
  AppLocalizations get localized => AppLocalizations.of(this)!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
