import 'package:purple_starter/common/database/shared_preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsDao {
  Future<void> setThemeMode(String value);
  String? get themeMode;
}

class SettingsDao extends SharedPreferencesDao implements ISettingsDao {
  SettingsDao(SharedPreferences sharedPreferences) : super(sharedPreferences);

  String get _isThemeLightKey => key("is_theme_light");

  @override
  Future<void> setThemeMode(String value) => setString(_isThemeLightKey, value);

  @override
  String? get themeMode => getString(_isThemeLightKey);
}
