import 'package:flutter/material.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/model/dependencies_storage.dart';
import 'package:purple_starter/src/core/model/repository_storage.dart';
import 'package:purple_starter/src/core/widget/dependencies_scope.dart';
import 'package:purple_starter/src/core/widget/environment_scope.dart';
import 'package:purple_starter/src/core/widget/repository_scope.dart';
import 'package:purple_starter/src/feature/app/bloc/initialization_bloc.dart';
import 'package:purple_starter/src/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/src/feature/app/widget/app_lifecycle_scope.dart';
import 'package:purple_starter/src/feature/settings/widget/scope/settings_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

class PurpleStarterApp extends StatelessWidget {
  final InitializationData initializationData;

  const PurpleStarterApp({
    Key? key,
    required this.initializationData,
  }) : super(key: key);

  PreferencesDriver get _preferencesDriver =>
      initializationData.preferencesDriver;

  @override
  Widget build(BuildContext context) => EnvironmentScope(
        create: initializationData.environmentStorage.constant,
        child: AppLifecycleScope(
          errorTrackingDisabler: initializationData.errorTrackingDisabler,
          child: DependenciesScope(
            create: (context) => DependenciesStorage(
              databaseName: 'purple_starter_database',
              preferencesDriver: _preferencesDriver,
            ),
            child: RepositoryScope(
              create: (context) => RepositoryStorage(
                appDatabase: DependenciesScope.of(context).database,
                preferencesDriver: _preferencesDriver,
              ),
              child: const SettingsScope(
                child: AppConfiguration(),
              ),
            ),
          ),
        ),
      );
}
