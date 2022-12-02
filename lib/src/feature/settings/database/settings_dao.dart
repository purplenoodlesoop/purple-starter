import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class ISettingsDao {
  PreferencesEntry<String> get themeMode;
}

class SettingsDao extends TypedPreferencesDao implements ISettingsDao {
  SettingsDao(PreferencesDriver driver) : super(driver);

  @override
  PreferencesEntry<String> get themeMode => stringEntry('theme_mode');
}
