import 'dart:async';

import 'package:arbor/arbor.dart';
import 'package:flutter/material.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/repository/configuration_repository.dart';
import 'package:purple_starter/src/feature/app/bloc/initialization_bloc.dart';
import 'package:purple_starter/src/feature/app/di/app_arbor_observer.dart';
import 'package:purple_starter/src/feature/app/di/bootstrap_dependencies.dart';
import 'package:purple_starter/src/feature/app/logger/error_reporting_message_processor.dart';
import 'package:purple_starter/src/feature/app/logger/pretty_ephemeral_message_processor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:stream_transform/stream_transform.dart';

typedef AppBuilder = Widget Function(
  InitializationData initializationData,
  ArborObserver observer,
  Logger logger,
  IConfigurationRepository configurationRepository,
);

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

mixin MainRunner {
  static void _runApp(
    Logger logger,
    AppBuilder appBuilder,
    InitializationHooks? hooks,
  ) {
    final arborObserver = AppArborObserver(logger);
    final BootstrapDependencies bootstrapDependencies =
        BootstrapDependenciesTree(
      logger: logger,
      observer: arborObserver,
    )..init();
    final initializationBloc = InitializationBloc(bootstrapDependencies)
      ..add(
        const InitializationEvent.initialize(),
      );
    StreamSubscription<InitializationState>? initializationSubscription;

    void terminate() {
      initializationSubscription?.cancel();
      initializationBloc.close();
      bootstrapDependencies.dispose();
    }

    void processInitializationState(InitializationState state) {
      state.map(
        notInitialized: (_) => hooks?.onStarted(),
        initializing: (state) => hooks?.onProgress(state.progress),
        initialized: (state) {
          terminate();
          Future<void>(() => hooks?.onInitialized(state));
          runApp(
            DefaultAssetBundle(
              bundle: SentryAssetBundle(),
              child: appBuilder(
                state,
                arborObserver,
                logger,
                bootstrapDependencies.configurationRepository,
              ),
            ),
          );
        },
        error: (state) {
          terminate();
          hooks?.onFailed(state.progress, state.error, state.stackTrace);
        },
      );
    }

    initializationSubscription = initializationBloc.stream
        .startWith(initializationBloc.state)
        .listen(processInitializationState, cancelOnError: false);
  }

  static void run({
    required AppBuilder appBuilder,
    InitializationHooks? hooks,
  }) {
    WidgetsFlutterBinding.ensureInitialized();
    final logger = Logger(
      processors: [
        PrettyEphemeralMessageProcessor(),
        ErrorReportingMessageProcessor(),
      ],
    );
    Chain.capture(() => _runApp(logger, appBuilder, hooks));
  }
}
