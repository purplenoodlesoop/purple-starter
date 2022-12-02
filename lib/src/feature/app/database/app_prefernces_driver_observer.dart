import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';
import 'package:typed_preferences/typed_preferences.dart';

const String _successfully = 'successfully';

extension on bool {
  String get status => this ? _successfully : 'un$_successfully';
}

class AppPreferencesDriverObserver
    with IdentityLoggingMixin
    implements PreferencesDriverObserver {
  const AppPreferencesDriverObserver();

  @override
  void onClear(bool isSuccess) {
    logData(
      (b) => b
        ..write('Cleared ')
        ..write(isSuccess.status),
    );
  }

  @override
  void beforeClear() {
    logData(
      (b) => b..write('Clearing..'),
    );
  }

  @override
  void beforeGet<T extends Object>(String path) {
    logData(
      (b) => b
        ..write('Reading ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write('..'),
    );
  }

  @override
  void beforeReload() {
    logData(
      (b) => b..write('Reloading..'),
    );
  }

  @override
  void beforeRemove<T extends Object>(String path) {
    logData(
      (b) => b
        ..write('Removing ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write('..'),
    );
  }

  @override
  void beforeSet<T extends Object>(String path, T value) {
    logData(
      (b) => b
        ..write('Setting ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write(' to ')
        ..write(value)
        ..write('..'),
    );
  }

  @override
  void onGet<T extends Object>(String path, T? value) {
    logData(
      (b) => b
        ..write('Read ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write('. Value: ')
        ..write(value),
    );
  }

  @override
  void onReload() {
    logData((b) => b..write('Reloaded'));
  }

  @override
  void onRemove<T extends Object>(String path, bool isSuccess) {
    logData(
      (b) => b
        ..write('Removed ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write(' ')
        ..write(isSuccess.status),
    );
  }

  @override
  void onSet<T extends Object>(String path, T value, bool isSuccess) {
    logData(
      (b) => b
        ..write('Set ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write(' ')
        ..write(isSuccess.status),
    );
  }
}
