import 'package:arbor/arbor.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/model/environment_storage.dart';
import 'package:purple_starter/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:purple_starter/src/feature/app/bloc/initialization_bloc.dart';
import 'package:purple_starter/src/feature/app/database/drift_logger.dart';
import 'package:purple_starter/src/feature/app/di/app_arbor_observer.dart';
import 'package:purple_starter/src/feature/app/logger/error_reporting_message_processor.dart';
import 'package:purple_starter/src/feature/app/logger/pretty_ephemeral_message_processor.dart';
import 'package:stream_bloc/stream_bloc.dart';

abstract class BootstrapDependencies
    implements
        Disposable,
        HasObserver,
        LoggerDependency,
        InitializationBlocDependencies {
  @override
  ArborObserver get observer;
}

class BootstrapDependenciesTree extends BaseTree<BootstrapDependenciesTree>
    implements
        BootstrapDependencies,
        AppBlocObserverDependencies,
        DriftLoggerDependencies,
        AppArborObserverDependencies {
  ObjectFactory<AppBlocObserver> get _blocObserver => instance(
        () => AppBlocObserver(this),
      );

  ObjectFactory<IDriftLogger> get _driftLogger => instance(
        () => DriftLogger(this),
      );

  bool _logTopLevelError(
    Object e,
    StackTrace s,
  ) {
    logger.error(e, stackTrace: s);

    return true;
  }

  void _logFlutterError(
    FlutterErrorDetails details,
  ) {
    logger.error(details.exceptionAsString(), stackTrace: details.stack);
  }

  void _setupStaticObservers() {
    PlatformDispatcher.instance.onError = _logTopLevelError;
    FlutterError.onError =
        FlutterError.onError?.amend(_logFlutterError) ?? _logFlutterError;
    StreamBlocObserver.current = _blocObserver();
    driftRuntimeOptions.debugPrint = _driftLogger().logQuery;
  }

  @override
  ObjectFactory<IEnvironmentStorage> get environmentStorage => instance(
        EnvironmentStorage.new,
      );

  @override
  Logger get logger => shared(
        () => Logger(
          processors: [
            PrettyEphemeralMessageProcessor(),
            ErrorReportingMessageProcessor(),
          ],
        ),
        dispose: (logger) => logger.dispose(),
      );

  @override
  ArborObserver get observer => shared(
        () => AppArborObserver(this),
      );

  @override
  void init() {
    super.init();
    _setupStaticObservers();
  }
}
