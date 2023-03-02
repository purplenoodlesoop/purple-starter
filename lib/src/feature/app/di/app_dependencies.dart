import 'package:arbor/arbor.dart';
import 'package:dio/dio.dart';
import 'package:mark/mark.dart';

import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/di/core_dependencies.dart';
import 'package:purple_starter/src/feature/app/di/core_observers.dart';
import 'package:purple_starter/src/feature/app/di/feature_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

class AppDependenciesTree extends BaseTree<AppDependenciesTree>
    implements
        AppDependencies,
        SharedParent<AppDependenciesTree>,
        CoreDependenciesModuleParent<AppDependenciesTree> {
  @override
  final SharedPreferences sharedPreferences;

  AppDependenciesTree({
    required this.sharedPreferences,
  });

  @override
  ArborObserver? get observer => coreObservers.arborObserver;

  @override
  AppDatabase get database => core.database;

  @override
  Dio get dio => core.dio;

  @override
  Logger get logger => core.logger;

  @override
  PreferencesDriver get preferencesDriver => core.preferencesDriver;

  @override
  CoreDependenciesModule<AppDependenciesTree> get core => module(
        CoreDependenciesModule.new,
      );

  @override
  FeatureDependencies get feature =>
      module<FeatureDependenciesModule<AppDependenciesTree>>(
        FeatureDependenciesModule.new,
      );

  @override
  CoreObservers get coreObservers =>
      module<CoreObserversModule<AppDependenciesTree>>(
        CoreObserversModule.new,
      );
}
