import 'package:arbor/arbor.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/repository/configuration_repository.dart';
import 'package:purple_starter/src/feature/app/di/app_feature_dependencies.dart';
import 'package:purple_starter/src/feature/settings/di/settings_dependencies.dart';

abstract class AppDependencies implements Lifecycle {
  CoreDependencies get core;
  FeatureDependencies get feature;
}

abstract class CoreDependencies {
  Logger get logger;
  IConfigurationRepository get configurationRepository;
}

abstract class FeatureDependencies {
  AppFeatureDependencies get app;
  SettingsDependencies get settings;
}
