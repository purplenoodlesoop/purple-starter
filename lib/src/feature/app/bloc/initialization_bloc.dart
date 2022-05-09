import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/core/model/environment_storage.dart';
import 'package:purple_starter/src/feature/app/logic/error_tracking_manager.dart';
import 'package:select_annotation/select_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'initialization_bloc.freezed.dart';
part 'initialization_bloc.select.dart';

@matchable
enum InitializationStep {
  environment,
  errorTracking,
  sharedPreferences,
}

@freezed
class InitializationProgress with _$InitializationProgress {
  const factory InitializationProgress({
    required InitializationStep currentStep,
    IEnvironmentStorage? environmentStorage,
    ErrorTrackingDisabler? errorTrackingDisabler,
  }) = _InitializationProgress;

  const InitializationProgress._();

  factory InitializationProgress.initial() => InitializationProgress(
        currentStep: InitializationStep.values.first,
      );

  int get stepsCompleted => InitializationStep.values.indexOf(currentStep);
}

@selectable
abstract class InitializationData {
  ErrorTrackingDisabler get errorTrackingDisabler;
  IEnvironmentStorage get environmentStorage;
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
    required IEnvironmentStorage environmentStorage,
    required ErrorTrackingDisabler errorTrackingDisabler,
    required SharedPreferences sharedPreferences,
  }) = InitializationInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.error({
    required InitializationProgress lastProgress,
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
  const factory InitializationEvent.initialize({
    required bool shouldSendSentry,
  }) = _Initialize;
}

abstract class InitializationFactories {
  IEnvironmentStorage createEnvironmentStorage();

  ErrorTrackingManager createErrorTrackingManager(
    IEnvironmentStorage environmentStorage,
  );
}

class InitializationBloc
    extends StreamBloc<InitializationEvent, InitializationState> {
  final InitializationFactories _factories;

  InitializationBloc({
    required InitializationFactories initializationFactories,
  })  : _factories = initializationFactories,
        super(const InitializationState.notInitialized());

  InitializationProgress get _currentProgress =>
      state.maybeCast<_IndexedInitializationStateMixin>()?.progress ??
      InitializationProgress.initial();

  Stream<InitializationState> _initialize(
    bool shouldSendSentry,
  ) async* {
    yield InitializationState.initializing(
      progress: InitializationProgress.initial(),
    );

    try {
      final environmentStorage = _factories.createEnvironmentStorage();
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.errorTracking,
          environmentStorage: environmentStorage,
        ),
      );

      final errorTrackingManager = _factories.createErrorTrackingManager(
        environmentStorage,
      );
      await errorTrackingManager.enableReporting(shouldSend: shouldSendSentry);
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.sharedPreferences,
          errorTrackingDisabler: errorTrackingManager,
        ),
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      yield InitializationState.initialized(
        environmentStorage: environmentStorage,
        errorTrackingDisabler: errorTrackingManager,
        sharedPreferences: sharedPreferences,
      );
    } on Object catch (e, s) {
      yield InitializationState.error(
        lastProgress: _currentProgress,
        error: e,
        stackTrace: s,
      );
      await _currentProgress.errorTrackingDisabler?.disableReporting();
      rethrow;
    }
  }

  @override
  Stream<InitializationState> mapEventToStates(InitializationEvent event) =>
      event.when(
        initialize: _initialize,
      );
}
