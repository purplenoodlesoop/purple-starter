import 'package:purple_starter/common/database/shared_preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsDao {
  Future<void> setIsThemeLight(bool value);
  bool? get isThemeLight;
}

class SettingsDao extends SharedPreferencesDao implements ISettingsDao {
  SettingsDao(SharedPreferences sharedPreferences) : super(sharedPreferences);

  String get _isThemeLightKey => key("is_theme_light");

  @override
  Future<void> setIsThemeLight(bool value) => setBool(_isThemeLightKey, value);

  @override
  bool? get isThemeLight => getBool(_isThemeLightKey);
}
