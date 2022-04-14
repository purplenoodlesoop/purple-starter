import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/widget/app_dependencies_scope.dart';
import 'package:purple_starter/src/feature/app/logic/sentry_init.dart';
import 'package:purple_starter/src/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/src/feature/app/widget/app_lifecycle_scope.dart';
import 'package:purple_starter/src/feature/settings/widget/scope/settings_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurpleStarterApp extends StatelessWidget {
  final SentrySubscription sentrySubscription;
  final SharedPreferences sharedPreferences;

  const PurpleStarterApp({
    Key? key,
    required this.sentrySubscription,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppLifecycleScope(
        sentrySubscription: sentrySubscription,
        child: AppDependenciesScope(
          databaseName: 'purple_starter_database',
          sharedPreferences: sharedPreferences,
          child: const SettingsScope(
            child: AppConfiguration(),
          ),
        ),
      );
}
