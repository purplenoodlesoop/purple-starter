// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/model/environment_storage.dart';
import 'package:purple_starter/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:purple_starter/src/feature/app/bloc/initialization_bloc.dart';
import 'package:purple_starter/src/feature/app/logic/error_tracking_manager.dart';
import 'package:purple_starter/src/feature/app/logic/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_bloc/stream_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

typedef AppBuilder = Widget Function(InitializationData initializationData);

abstract class InitializationHooks {
  const InitializationHooks();

  @mustCallSuper
  @protected
  void onStarted() {}

  @mustCallSuper
  @protected
  void onProgress(InitializationProgress progress) {}

  @mustCallSuper
  @protected
  void onInitialized(InitializationData initializationData) {}

  @mustCallSuper
  @protected
  void onFailed(
    InitializationProgress lastProgress,
    Object error,
    StackTrace stackTrace,
  ) {}
}

class _InitializationFactories implements InitializationFactories {
  const _InitializationFactories();

  @override
  IEnvironmentStorage createEnvironmentStorage() => const EnvironmentStorage();

  @override
  ErrorTrackingManager createErrorTrackingManager(
    IEnvironmentStorage environment,
  ) =>
      SentryTrackingManager(sentryDsn: environment.sentryDsn);
}

mixin MainRunner {
  static void _amendFlutterError() {
    const log = Logger.logFlutterError;

    FlutterError.onError = FlutterError.onError?.amend(log) ?? log;
  }

  static T? _runZoned<T>(T Function() body) => Logger.runLogging(
        () => StreamBlocObserver.inject(
          const AppBlocObserver(),
          () => runZonedGuarded(
            body,
            Logger.logZoneError,
          ),
        ),
      );

  static void _runApp({
    required bool shouldSend,
    required AppBuilder appBuilder,
    required InitializationHooks? hooks,
  }) {
    final initializationBloc = InitializationBloc(
      initializationFactories: const _InitializationFactories(),
    )..add(
        InitializationEvent.initialize(shouldSendSentry: shouldSend),
      );
    StreamSubscription<InitializationState>? initializationSubscription;

    void terminate() {
      initializationSubscription?.cancel();
      initializationBloc.close();
    }

    void processInitializationState(InitializationState state) {
      // ignore: avoid-ignoring-return-values
      state.map(
        notInitialized: (_) => hooks?.onStarted(),
        initializing: (state) => hooks?.onProgress(state.progress),
        initialized: (state) {
          terminate();
          Future<void>(() => hooks?.onInitialized(state));
          runApp(
            DefaultAssetBundle(
              bundle: SentryAssetBundle(),
              child: appBuilder(state),
            ),
          );
        },
        error: (state) {
          terminate();
          hooks?.onFailed(state.lastProgress, state.error, state.stackTrace);
        },
      );
    }

    initializationSubscription = initializationBloc.stream
        .startWith(initializationBloc.state)
        .listen(processInitializationState, cancelOnError: false);
  }

  static void run({
    required AppBuilder appBuilder,
    bool shouldSend = !kDebugMode,
    InitializationHooks? hooks,
  }) {
    _runZoned(
      () {
        // ignore: avoid-ignoring-return-values
        WidgetsFlutterBinding.ensureInitialized();
        _amendFlutterError();
        _runApp(shouldSend: shouldSend, appBuilder: appBuilder, hooks: hooks);
      },
    );
  }
}
