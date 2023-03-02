import 'package:flutter/material.dart';
import 'package:flutter_arbor/flutter_arbor.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/widget/environment_scope.dart';
import 'package:purple_starter/src/feature/app/bloc/initialization_bloc.dart';
import 'package:purple_starter/src/feature/app/di/app_dependencies.dart';
import 'package:purple_starter/src/feature/app/widget/app_configuration.dart';
import 'package:purple_starter/src/feature/app/widget/app_lifecycle_scope.dart';
import 'package:purple_starter/src/feature/settings/widget/scope/settings_scope.dart';

class PurpleStarterApp extends StatelessWidget {
  final InitializationData initializationData;

  const PurpleStarterApp({
    required this.initializationData,
    super.key,
  });

  @override
  Widget build(BuildContext context) => EnvironmentScope(
        create: initializationData.environmentStorage.constant,
        child: AppLifecycleScope(
          child: NodeScope<AppDependencies>(
            create: (context) => AppDependenciesTree(
              sharedPreferences: initializationData.sharedPreferences,
            ),
            child: const SettingsScope(
              child: AppConfiguration(),
            ),
          ),
        ),
      );
}
