import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/extension/src/stream.dart';
import 'package:purple_starter/src/core/repository/configuration_repository.dart';
import 'package:select_annotation/select_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'initialization_bloc.freezed.dart';
part 'initialization_bloc.select.dart';

@matchable
enum InitializationStep {
  errorTracking,
  sharedPreferences,
}

@freezed
class InitializationProgress with _$InitializationProgress {
  const factory InitializationProgress({
    required InitializationStep currentStep,
  }) = _InitializationProgress;

  const InitializationProgress._();

  factory InitializationProgress.initial() => InitializationProgress(
        currentStep: InitializationStep.values.first,
      );

  int get stepsCompleted => InitializationStep.values.indexOf(currentStep);
}

@selectable
abstract class InitializationData {
  SharedPreferences get sharedPreferences;
}

@selectable
mixin _IndexedInitializationStateMixin {
  InitializationProgress get progress;

  int get stepsCompleted => progress.stepsCompleted;
}

@freezed
class InitializationState with _$InitializationState {
  const InitializationState._();

  const factory InitializationState.notInitialized() =
      InitializationNotInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.initializing({
    required InitializationProgress progress,
  }) = InitializationInitializing;

  @Implements<InitializationData>()
  const factory InitializationState.initialized({
    required SharedPreferences sharedPreferences,
  }) = InitializationInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.error({
    required InitializationProgress progress,
    required Object error,
    required StackTrace stackTrace,
  }) = InitializationError;

  int get stepsCompleted => map(
        notInitialized: 0.constant,
        initializing: _IndexedInitializationStateMixin$.stepsCompleted,
        initialized: InitializationStep.values.length.constant,
        error: _IndexedInitializationStateMixin$.stepsCompleted,
      );
}

@freezed
class InitializationEvent with _$InitializationEvent {
  const factory InitializationEvent.initialize() = _Initialize;
}

abstract class InitializationBlocDependencies
    implements ConfigurationRepositoryDependency {}

class InitializationBloc
    extends StreamBloc<InitializationEvent, InitializationState> {
  final InitializationBlocDependencies _dependencies;

  InitializationBloc(this._dependencies)
      : super(const InitializationState.notInitialized());

  InitializationProgress get _currentProgress =>
      state.maybeCast<_IndexedInitializationStateMixin>()?.progress ??
      InitializationProgress.initial();

  Stream<InitializationState> _initialize() async* {
    yield InitializationState.initializing(
      progress: InitializationProgress.initial(),
    );

    try {
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.errorTracking,
        ),
      );

      await SentryFlutter.init(
        (options) => options
          ..dsn = _dependencies.configurationRepository.sentryDsn
          ..environment = _dependencies.configurationRepository.environment.name
          ..tracesSampleRate = 1,
      );
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.sharedPreferences,
        ),
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      yield InitializationState.initialized(
        sharedPreferences: sharedPreferences,
      );
    } on Object catch (e, s) {
      yield InitializationState.error(
        progress: _currentProgress,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Stream<InitializationState> mapEventToStates(InitializationEvent event) =>
      event.when(
        initialize: _initialize,
      );

  @override
  Stream<Transition<InitializationEvent, InitializationState>> transformEvents(
    Stream<InitializationEvent> events,
    TransitionFunction<InitializationEvent, InitializationState> transitionFn,
  ) =>
      events.exhaustMap(transitionFn);
}
