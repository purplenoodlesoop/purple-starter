import 'package:pure/pure.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';

abstract class ISettingsRepository {
  AppTheme? get theme;
  Future<void> setTheme(AppTheme value);
}

class SettingsRepository implements ISettingsRepository {
  final ISettingsDao _settingsDao;

  SettingsRepository({
    required ISettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  @override
  AppTheme? get theme =>
      AppTheme.values.byName.nullable(_settingsDao.themeMode.value);

  @override
  Future<void> setTheme(AppTheme value) =>
      _settingsDao.themeMode.setValue(value.name);
}
