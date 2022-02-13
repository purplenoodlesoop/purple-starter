import 'package:flutter/material.dart';
import 'package:purple_starter/common/widget/app_dependencies_scope.dart';
import 'package:purple_starter/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/feature/settings/widget/scope/settings_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurpleStarterApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const PurpleStarterApp({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppDependenciesScope(
        databaseName: "purple_starter_database",
        sharedPreferences: sharedPreferences,
        child: const SettingsScope(
          child: AppConfiguration(),
        ),
      );
}
