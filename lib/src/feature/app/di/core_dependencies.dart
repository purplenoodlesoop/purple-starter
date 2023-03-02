import 'package:dio/dio.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/api/dio_logger_interceptor.dart';
import 'package:purple_starter/src/feature/app/database/app_preferences_driver_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class CoreDependenciesModuleParent<
    P extends CoreDependenciesModuleParent<P>> implements SharedParent<P> {
  SharedPreferences get sharedPreferences;
}

class CoreDependenciesModule<P extends CoreDependenciesModuleParent<P>>
    extends SharedBaseModule<CoreDependenciesModule<P>, P>
    implements
        CoreDependencies,
        DioLoggerInterceptorDependencies,
        AppPreferencesDriverObserverDependencies {
  CoreDependenciesModule(super.parent);

  @override
  AppDatabase get database => shared(
        () => AppDatabase(
          name: 'purple_starter_database',
        ),
        dispose: (database) => database.close(),
      );

  @override
  Dio get dio => shared(
        () => Dio()
          ..interceptors.addAll([
            DioLoggerInterceptor(this),
          ]),
        dispose: (dio) => dio.close(),
      );

  @override
  PreferencesDriver get preferencesDriver => shared(
        () => PreferencesDriver(
          sharedPreferences: parent.sharedPreferences,
          observers: [
            AppPreferencesDriverObserver(this),
          ],
        ),
      );

  @override
  void dispose() {
    logger.dispose();
    super.dispose();
  }
}
