part of 'typed_preferences_dao.dart';

abstract class _BasePreferencesEntry<T> implements PreferencesEntry<T> {
  final String _key;
  final ISharedPreferencesDao _delegate;

  _BasePreferencesEntry._(String key, this._delegate)
      : _key = _delegate.key(key);

  @override
  bool get exists => _delegate.containsKey(_key);

  @override
  Future<bool> remove() => _delegate.remove(_key);
}

class _BoolEntry extends _BasePreferencesEntry<bool> {
  _BoolEntry(String key, ISharedPreferencesDao delegate)
      : super._(key, delegate);

  @override
  bool? get value => _delegate.getBool(_key);

  @override
  Future<bool> setValue(bool value) => _delegate.setBool(_key, value);
}

class _IntEntry extends _BasePreferencesEntry<int> {
  _IntEntry(String key, ISharedPreferencesDao delegate)
      : super._(key, delegate);

  @override
  int? get value => _delegate.getInt(_key);

  @override
  Future<bool> setValue(int value) => _delegate.setInt(_key, value);
}

class _DoubleEntry extends _BasePreferencesEntry<double> {
  _DoubleEntry(String key, ISharedPreferencesDao delegate)
      : super._(key, delegate);

  @override
  double? get value => _delegate.getDouble(_key);

  @override
  Future<bool> setValue(double value) => _delegate.setDouble(_key, value);
}

class _StringEntry extends _BasePreferencesEntry<String> {
  _StringEntry(String key, ISharedPreferencesDao delegate)
      : super._(key, delegate);

  @override
  String? get value => _delegate.getString(_key);

  @override
  Future<bool> setValue(String value) => _delegate.setString(_key, value);
}

class _StringListEntry extends _BasePreferencesEntry<List<String>> {
  _StringListEntry(String key, ISharedPreferencesDao delegate)
      : super._(key, delegate);

  @override
  List<String>? get value => _delegate.getStringList(_key);

  @override
  Future<bool> setValue(List<String> value) =>
      _delegate.setStringList(_key, value);
}
