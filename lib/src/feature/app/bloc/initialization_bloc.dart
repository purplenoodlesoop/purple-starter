import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/feature/app/logic/sentry_init.dart';
import 'package:select_annotation/select_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'initialization_bloc.freezed.dart';
part 'initialization_bloc.select.dart';

@matchable
enum InitializationStep {
  sentry,
  sharedPreferences,
}

@freezed
class InitializationProgress with _$InitializationProgress {
  static const InitializationProgress initial = InitializationProgress(
    currentStep: InitializationStep.sentry,
  );

  const factory InitializationProgress({
    required InitializationStep currentStep,
    StreamSubscription<void>? sentrySubscription,
  }) = _InitializationProgress;
}

@selectable
mixin _IndexedInitializationStateMixin {
  InitializationProgress get progress;

  int get index => InitializationStep.values.indexOf(progress.currentStep) + 1;
}

@freezed
class InitializationState with _$InitializationState {
  const InitializationState._();

  const factory InitializationState.notInitialized() = _NotInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.initializing({
    required InitializationProgress progress,
  }) = _Initializing;

  const factory InitializationState.initialized({
    required SharedPreferences sharedPreferences,
    required StreamSubscription<void> sentrySubscription,
  }) = _Initialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.error({
    required InitializationProgress progress,
    required String description,
  }) = _Error;

  int get stepsCompleted => map(
        notInitialized: 0.constant,
        initializing: _IndexedInitializationStateMixin$.index,
        initialized: InitializationStep.values.length.constant,
        error: _IndexedInitializationStateMixin$.index,
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
  InitializationBloc() : super(const InitializationState.notInitialized());

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
      // ignore: cancel_subscriptions
      final sentrySubscription = await SentryInit.init(
        shouldSend: shouldSendSentry,
      );
      yield InitializationState.initializing(
        progress: _currentProgress.copyWith(
          currentStep: InitializationStep.sharedPreferences,
          sentrySubscription: sentrySubscription,
        ),
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      yield InitializationState.initialized(
        sharedPreferences: sharedPreferences,
        sentrySubscription: sentrySubscription,
      );
    } on Object catch (e) {
      yield InitializationState.error(
        progress: _currentProgress,
        description: e.toString(),
      );
      rethrow;
    }
  }

  @override
  Stream<InitializationState> mapEventToStates(InitializationEvent event) =>
      event.when(
        initialize: _initialize,
      );
}
