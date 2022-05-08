import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/feature/app/logic/error_tracking_manager.dart';
import 'package:select_annotation/select_annotation.dart';
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
  static const InitializationProgress initial = InitializationProgress(
    currentStep: InitializationStep.errorTracking,
  );

  const factory InitializationProgress({
    required InitializationStep currentStep,
    ErrorTrackingDisabler? errorTrackingDisabler,
  }) = _InitializationProgress;

  const InitializationProgress._();

  int get stepsCompleted => InitializationStep.values.indexOf(currentStep);
}

@selectable
abstract class InitializationData {
  SharedPreferences get sharedPreferences;
  ErrorTrackingDisabler get errorTrackingDisabler;
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
    required ErrorTrackingDisabler errorTrackingDisabler,
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

class InitializationBloc
    extends StreamBloc<InitializationEvent, InitializationState> {
  final ErrorTrackingManager _errorTrackingManager;

  InitializationBloc({
    required ErrorTrackingManager errorTrackingManager,
  })  : _errorTrackingManager = errorTrackingManager,
        super(const InitializationState.notInitialized());

  InitializationProgress get _currentProgress =>
      state.maybeCast<_IndexedInitializationStateMixin>()?.progress ??
      InitializationProgress.initial;

  Stream<InitializationState> _initialize(
    bool shouldSendSentry,
  ) async* {
    yield const InitializationState.initializing(
      progress: InitializationProgress.initial,
    );

    try {
      await _errorTrackingManager.enableReporting(shouldSend: shouldSendSentry);
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.sharedPreferences,
          errorTrackingDisabler: _errorTrackingManager,
        ),
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      yield InitializationState.initialized(
        sharedPreferences: sharedPreferences,
        errorTrackingDisabler: _errorTrackingManager,
      );
    } on Object catch (e, s) {
      yield InitializationState.error(
        lastProgress: _currentProgress,
        error: e,
        stackTrace: s,
      );
      await _errorTrackingManager.disableReporting();
      rethrow;
    }
  }

  @override
  Stream<InitializationState> mapEventToStates(InitializationEvent event) =>
      event.when(
        initialize: _initialize,
      );
}