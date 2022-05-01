import 'package:flutter/foundation.dart';
import 'package:l/l.dart';
import 'package:pure/pure.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISharedPreferencesDao implements SharedPreferences {
  String key(String name);
}

abstract class BaseSharedPreferencesDao implements ISharedPreferencesDao {
  final SharedPreferences _sharedPreferences;
  final String _name;

  BaseSharedPreferencesDao(
    SharedPreferences sharedPreferences, {
    required String name,
  })  : _sharedPreferences = sharedPreferences,
        _name = name;
}

mixin _LoggerMixin on BaseSharedPreferencesDao {
  late final String _logOrigin =
      kDebugMode ? '$runtimeType($_name)' : 'SharedPreferencesDao($_name)';

  void _log(void Function(StringBuffer b) buildLog) {
    final buffer = StringBuffer(_logOrigin)..write(' | ');

    buildLog(buffer);

    l.i(buffer.toString());
  }

  Future<T> _performAsyncLogging<T>(
    String description,
    Future<T> Function() action,
  ) async {
    _log(
      (b) => b
        ..write('Performing')
        ..write('"')
        ..write(description)
        ..write('".'),
    );

    final result = await action();

    _log(
      (b) => b
        ..write('Successfully performed')
        ..write('"')
        ..write(description)
        ..write('".'),
    );

    return result;
  }

  T _getLogging<T>(String key, T Function(String key) read) {
    _log(
      (b) => b
        ..write('Reading key ')
        ..write('"')
        ..write(key)
        ..write('" of type ')
        ..write(T)
        ..write('.'),
    );

    final value = read(key);

    _log(
      (b) => b
        ..write('Successfully read key ')
        ..write('"')
        ..write(key)
        ..write('". Value – ')
        ..write(value)
        ..write('.'),
    );

    return value;
  }

  Future<bool> _setLogging<T>(
    String key,
    T value,
    Future<bool> Function(String key, T value) set,
  ) async {
    _log(
      (b) => b
        ..write('Writing key ')
        ..write('"')
        ..write(key)
        ..write('" with value ')
        ..write(value)
        ..write('.'),
    );

    final hasSet = await set(key, value);

    _log(
      (b) => b
        ..write('Wrote key ')
        ..write('"')
        ..write(key)
        ..write('" ')
        ..write(hasSet ? 'successfully' : 'unsuccessfully')
        ..write('.'),
    );

    return hasSet;
  }
}

mixin _KeyImplementationMixin on BaseSharedPreferencesDao {
  late final String _fullNamespace = 'purple_starter.$_name';
  late final F1<String, String> _memoizedKey = _key.memoize();

  String _key(String name) => '$_fullNamespace.$name';

  @override
  String key(String name) => _memoizedKey(name);
}

mixin _ActionsImplementationMixin on _LoggerMixin {
  @override
  Future<bool> clear() =>
      _performAsyncLogging('clear', _sharedPreferences.clear);

  @override
  @Deprecated('Deprecated for iOS')
  Future<bool> commit() =>
      _performAsyncLogging('commit', _sharedPreferences.clear);

  @override
  Future<void> reload() =>
      _performAsyncLogging('reload', _sharedPreferences.reload);

  @override
  bool containsKey(String key) {
    _log(
      (b) => b
        ..write('Checking if key "')
        ..write(key)
        ..write('" exists.'),
    );

    final exists = _sharedPreferences.containsKey(key);

    _log(
      (b) => b
        ..write('Key "')
        ..write(key)
        ..write('" ')
        ..write(exists ? 'exists' : 'does not exist')
        ..write('.'),
    );

    return exists;
  }
}

mixin _GettersImplementationMixin on _LoggerMixin {
  @override
  // ignore: no-object-declaration
  Object? get(String key) => _getLogging(key, _sharedPreferences.get);

  @override
  bool? getBool(String key) => _getLogging(key, _sharedPreferences.getBool);

  @override
  double? getDouble(String key) =>
      _getLogging(key, _sharedPreferences.getDouble);

  @override
  int? getInt(String key) => _getLogging(key, _sharedPreferences.getInt);

  @override
  String? getString(String key) =>
      _getLogging(key, _sharedPreferences.getString);

  @override
  List<String>? getStringList(String key) =>
      _getLogging(key, _sharedPreferences.getStringList);

  @override
  Set<String> getKeys() {
    _log(
      (b) => b.write('Getting all keys.'),
    );

    final keys = _sharedPreferences.getKeys();

    _log(
      (b) => b
        ..write('Successfully got all keys.')
        ..write('Keys – ')
        ..write(keys)
        ..write('.'),
    );

    return keys;
  }
}

mixin _MutationsImplementationMixin on _LoggerMixin {
  @override
  Future<bool> setBool(String key, bool value) =>
      _setLogging(key, value, _sharedPreferences.setBool);

  @override
  Future<bool> setDouble(String key, double value) =>
      _setLogging(key, value, _sharedPreferences.setDouble);

  @override
  Future<bool> setInt(String key, int value) =>
      _setLogging(key, value, _sharedPreferences.setInt);

  @override
  Future<bool> setString(String key, String value) =>
      _setLogging(key, value, _sharedPreferences.setString);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _setLogging(key, value, _sharedPreferences.setStringList);

  @override
  Future<bool> remove(String key) async {
    _log(
      (b) => b
        ..write('Removing key ')
        ..write('"')
        ..write(key)
        ..write('".'),
    );

    final hasRemoved = await _sharedPreferences.remove(key);

    _log(
      (b) => b
        ..write('Removed key ')
        ..write('"')
        ..write(key)
        ..write('" ')
        ..write(hasRemoved ? 'successfully' : 'unsuccessfully')
        ..write('.'),
    );

    return hasRemoved;
  }
}

abstract class SharedPreferencesDao = BaseSharedPreferencesDao
    with
        _LoggerMixin,
        _KeyImplementationMixin,
        _ActionsImplementationMixin,
        _GettersImplementationMixin,
        _MutationsImplementationMixin;
