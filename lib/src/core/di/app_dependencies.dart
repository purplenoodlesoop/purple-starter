import 'package:arbor/arbor.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/feature/settings/di/settings_dependencies.dart';

abstract class AppDependencies implements Lifecycle {
  CoreDependencies get core;
  FeatureDependencies get feature;
}

abstract class CoreDependencies {
  Logger get logger;
}

abstract class FeatureDependencies {
  SettingsDependencies get settings;
}
