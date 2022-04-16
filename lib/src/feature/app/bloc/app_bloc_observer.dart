import 'package:l/l.dart';
import 'package:stream_bloc/stream_bloc.dart';

extension on StringBuffer {
  void writeType(Object? object) {
    write(object.runtimeType);
  }
}

class AppBlocObserver extends StreamBlocObserver {
  const AppBlocObserver();

  void _log(void Function(StringBuffer buffer) assemble) {
    final buffer = StringBuffer(runtimeType)..write(' | ');
    assemble(buffer);
    l.d(buffer.toString());
  }

  @override
  void onCreate(Closable closable) {
    super.onCreate(closable);
    _log(
      (buffer) => buffer
        ..write('Created ')
        ..writeType(closable),
    );
  }

  @override
  void onEvent(BlocEventSink<Object?> eventSink, Object? event) {
    super.onEvent(eventSink, event);
    if (event != null) {
      _log(
        (buffer) => buffer
          ..write('Event ')
          ..writeType(event)
          ..write(' in ')
          ..writeType(eventSink),
      );
    }
  }

  @override
  void onTransition(BlocEventSink<Object?> bloc, Transition transition) {
    super.onTransition(bloc, transition);

    final Object? event = transition.event;

    if (event != null) {
      _log(
        (buffer) => buffer
          ..write('Transition in ')
          ..writeType(bloc)
          ..write(' with ')
          ..writeType(event)
          ..write(': ')
          ..writeType(transition.currentState)
          ..write(' -> ')
          ..writeType(transition.nextState),
      );
    }
  }

  @override
  void onError(ErrorSink errorSink, Object error, StackTrace stackTrace) {
    super.onError(errorSink, error, stackTrace);

    _log(
      (buffer) => buffer
        ..write('Error ')
        ..writeType(error)
        ..write(' in ')
        ..writeType(errorSink),
    );

    l.e(error, stackTrace);
  }

  @override
  void onClose(Closable closable) {
    super.onClose(closable);
    _log(
      (buffer) => buffer
        ..write('Closed ')
        ..writeType(closable),
    );
  }
}
