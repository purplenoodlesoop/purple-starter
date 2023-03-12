// ignore_for_file: avoid-dynamic

import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';
import 'package:stream_bloc/stream_bloc.dart';

extension on StringBuffer {
  /// Writes the type of the object in debug mode to make logs **readable** and
  /// write the object's [toString] in release mode to make logs
  /// **informative**.
  void writeInfo(Object? object) {
    Type? type;

    // Not a real assert, just a way to get the type of
    // the object only in debug mode.
    // ignore: prefer_asserts_with_message
    assert(
      () {
        type = object.runtimeType;

        return true;
      }(),
    );

    write(type ?? object);
  }
}

abstract class AppBlocObserverDependencies implements LoggerDependency {}

class AppBlocObserver extends StreamBlocObserver with IdentityLoggingMixin {
  final AppBlocObserverDependencies _dependencies;

  AppBlocObserver(this._dependencies);

  @override
  Logger get logger => _dependencies.logger;

  @override
  void onCreate(Closable closable) {
    super.onCreate(closable);
    log(
      (buffer) => buffer
        ..write('Created ')
        ..writeInfo(closable),
    );
  }

  @override
  void onEvent(BlocEventSink<Object?> eventSink, Object? event) {
    super.onEvent(eventSink, event);
    if (event != null) {
      log(
        (buffer) => buffer
          ..write('Event ')
          ..writeInfo(event)
          ..write(' in ')
          ..writeInfo(eventSink),
      );
    }
  }

  @override
  void onTransition(
    BlocEventSink<Object?> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);

    final Object? event = transition.event;

    if (event != null) {
      log(
        (buffer) => buffer
          ..write('Transition in ')
          ..writeInfo(bloc)
          ..write(' with ')
          ..writeInfo(event)
          ..write(': ')
          ..writeInfo(transition.currentState)
          ..write(' -> ')
          ..writeInfo(transition.nextState),
      );
    }
  }

  @override
  void onError(ErrorSink errorSink, Object error, StackTrace stackTrace) {
    super.onError(errorSink, error, stackTrace);

    log(
      (buffer) => buffer
        ..write('Error ')
        ..writeInfo(error)
        ..write(' in ')
        ..writeInfo(errorSink),
    );

    logger.error(error, stackTrace: stackTrace);
  }

  @override
  void onClose(Closable closable) {
    super.onClose(closable);
    log(
      (buffer) => buffer
        ..write('Closed ')
        ..writeInfo(closable),
    );
  }
}
