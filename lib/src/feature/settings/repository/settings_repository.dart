import 'package:pure/pure.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/src/feature/settings/model/settings_data.dart';

abstract class ISettingsRepository {
  SettingsData currentData();

  Future<void> setTheme(AppTheme value);
}

class SettingsRepository implements ISettingsRepository {
  final ISettingsDao _settingsDao;

  SettingsRepository({
    required ISettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  AppTheme? get _theme =>
      AppTheme.values.byName.nullable(_settingsDao.themeMode.value);

  @override
  SettingsData currentData() => SettingsData(
        theme: _theme ?? AppTheme.system,
      );

  @override
  Future<void> setTheme(AppTheme value) =>
      _settingsDao.themeMode.setValue(value.name);
}
