import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';
import 'package:typed_preferences/typed_preferences.dart';

const String _successfully = 'successfully';

extension on bool {
  String get status => this ? _successfully : 'un$_successfully';
}

abstract class AppPreferencesDriverObserverDependencies
    implements LoggerDependency {}

class AppPreferencesDriverObserver
    with IdentityLoggingMixin
    implements PreferencesDriverObserver {
  final AppPreferencesDriverObserverDependencies _dependencies;

  AppPreferencesDriverObserver(this._dependencies);

  @override
  Logger get logger => _dependencies.logger;

  @override
  void onClear(bool isSuccess) {
    log(
      (b) => b
        ..write('Cleared ')
        ..write(isSuccess.status),
    );
  }

  @override
  void beforeClear() {
    log(
      (b) => b..write('Clearing..'),
    );
  }

  @override
  void beforeGet<T extends Object>(String path) {
    log(
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
    log(
      (b) => b..write('Reloading..'),
    );
  }

  @override
  void beforeRemove<T extends Object>(String path) {
    log(
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
    log(
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
    log(
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
    log((b) => b..write('Reloaded'));
  }

  @override
  void onRemove<T extends Object>(String path, bool isSuccess) {
    log(
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
    log(
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
