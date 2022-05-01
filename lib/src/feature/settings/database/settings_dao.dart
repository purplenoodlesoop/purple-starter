import 'package:purple_starter/src/core/database/shared_preferences/shared_preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsDao {
  abstract final String? themeMode;
  Future<void> setThemeMode(String value);
}

class SettingsDao extends SharedPreferencesDao implements ISettingsDao {
  SettingsDao({
    required SharedPreferences sharedPreferences,
  }) : super(sharedPreferences, name: 'settings');

  String get _themeModeKey => key('theme_mode');

  @override
  String? get themeMode => getString(_themeModeKey);

  @override
  Future<void> setThemeMode(String value) => setString(_themeModeKey, value);
}
