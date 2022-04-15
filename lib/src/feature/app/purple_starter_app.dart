import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/model/dependencies_storage.dart';
import 'package:purple_starter/src/core/model/repository_storage.dart';
import 'package:purple_starter/src/core/widget/dependencies_scope.dart';
import 'package:purple_starter/src/core/widget/repository_scope.dart';
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
        child: DependenciesScope(
          create: (context) => DependenciesStorage(
            databaseName: 'purple_starter_database',
            sharedPreferences: sharedPreferences,
          ),
          child: RepositoryScope(
            create: (context) => RepositoryStorage(
              appDatabase: DependenciesScope.of(context).database,
              sharedPreferences: sharedPreferences,
            ),
            child: const SettingsScope(
              child: AppConfiguration(),
            ),
          ),
        ),
      );
}
