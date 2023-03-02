import 'package:arbor/arbor.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/api/dio_logger_interceptor.dart';
import 'package:purple_starter/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:purple_starter/src/feature/app/database/app_preferences_driver_observer.dart';
import 'package:purple_starter/src/feature/app/database/drift_logger.dart';
import 'package:purple_starter/src/feature/app/di/app_arbor_observer.dart';
import 'package:purple_starter/src/feature/app/logger/error_reporting_message_processor.dart';
import 'package:purple_starter/src/feature/app/logger/pretty_ephemeral_message_processor.dart';
import 'package:stream_bloc/stream_bloc.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class CoreObservers {
  List<Interceptor> get dioInterceptors;
  List<PreferencesDriverObserver> get typedPreferencesObservers;
  List<MessageProcessor> get messageProcessors;
  ArborObserver get arborObserver;
}

class CoreObserversModule<P extends SharedParent<P>>
    extends SharedBaseModule<CoreObserversModule<P>, P>
    implements
        CoreObservers,
        AppBlocObserverDependencies,
        DriftLoggerDependencies,
        DioLoggerInterceptorDependencies,
        AppPreferencesDriverObserverDependencies,
        AppArborObserverDependencies {
  CoreObserversModule(super.parent);

  ObjectFactory<AppBlocObserver> get _blocObserver => instance(
        () => AppBlocObserver(this),
      );

  ObjectFactory<IDriftLogger> get _driftLogger => instance(
        () => DriftLogger(this),
      );

  @override
  List<Interceptor> get dioInterceptors => shared(
        () => [
          DioLoggerInterceptor(this),
        ],
      );

  @override
  List<PreferencesDriverObserver> get typedPreferencesObservers => shared(
        () => [
          AppPreferencesDriverObserver(this),
        ],
      );

  @override
  List<MessageProcessor> get messageProcessors => shared(
        () => [
          PrettyEphemeralMessageProcessor(),
          ErrorReportingMessageProcessor(),
        ],
      );

  @override
  ArborObserver get arborObserver => shared(
        () => AppArborObserver(this),
      );

  void _setupStaticObservers() {
    StreamBlocObserver.current = _blocObserver();
    driftRuntimeOptions.debugPrint = _driftLogger().logQuery;
  }

  @override
  void init() {
    super.init();
    _setupStaticObservers();
  }
}
