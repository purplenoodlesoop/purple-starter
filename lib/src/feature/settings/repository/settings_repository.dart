import 'package:pure/pure.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';

abstract class ISettingsRepository {
  abstract final AppTheme? theme;
  Future<void> setTheme(AppTheme value);
}

class SettingsRepository implements ISettingsRepository {
  final ISettingsDao _settingsDao;

  SettingsRepository({
    required ISettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  @override
  AppTheme? get theme => _settingsDao.themeMode?.pipe(AppThemeX.fromString);

  @override
  Future<void> setTheme(AppTheme value) =>
      _settingsDao.setThemeMode(value.name);
}
