import 'package:typed_preferences/typed_preferences.dart';

abstract class ISettingsDao {
  PreferencesEntry<String> get themeMode;
}

abstract class SettingsDaoDependency {
  ISettingsDao get settingsDao;
}

class SettingsDao extends TypedPreferencesDao implements ISettingsDao {
  SettingsDao(super.driver);

  @override
  PreferencesEntry<String> get themeMode => stringEntry('theme_mode');
}
