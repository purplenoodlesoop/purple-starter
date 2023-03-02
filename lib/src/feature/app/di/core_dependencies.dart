import 'package:dio/dio.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/database/app_preferences_driver_observer.dart';
import 'package:purple_starter/src/feature/app/di/core_observers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class CoreDependenciesModuleParent<
    P extends CoreDependenciesModuleParent<P>> implements SharedParent<P> {
  SharedPreferences get sharedPreferences;
  CoreObservers get coreObservers;
}

class CoreDependenciesModule<P extends CoreDependenciesModuleParent<P>>
    extends SharedBaseModule<CoreDependenciesModule<P>, P>
    implements CoreDependencies {
  CoreDependenciesModule(super.parent);

  @override
  Logger get logger => shared(
        () => Logger(
          processors: parent.coreObservers.messageProcessors,
        ),
        dispose: (logger) => logger.dispose(),
      );

  @override
  AppDatabase get database => shared(
        () => AppDatabase(
          name: 'purple_starter_database',
        ),
        dispose: (database) => database.close(),
      );

  @override
  Dio get dio => shared(
        () => Dio()..interceptors.addAll(parent.coreObservers.dioInterceptors),
        dispose: (dio) => dio.close(),
      );

  @override
  PreferencesDriver get preferencesDriver => shared(
        () => PreferencesDriver(
          sharedPreferences: parent.sharedPreferences,
          observers: parent.coreObservers.typedPreferencesObservers,
        ),
      );
}
