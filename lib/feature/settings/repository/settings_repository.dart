import 'package:l/l.dart';
import 'package:pure/pure.dart';
import 'package:purple_starter/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/feature/settings/enum/app_theme.dart';

abstract class ISettingsRepository {
  Future<void> setTheme(AppTheme value);
  AppTheme? get theme;
}

class SettingsRepository implements ISettingsRepository {
  final ISettingsDao _settingsDao;

  SettingsRepository({
    required SettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  @override
  Future<void> setTheme(AppTheme value) async {
    l.i("Setting theme to ${value.name}");
    await _settingsDao.setIsThemeLight(value == AppTheme.light);
    l.i("Set theme successfully");
  }

  @override
  AppTheme? get theme => _settingsDao.isThemeLight?.pipe(
        (isThemeLight) => isThemeLight ? AppTheme.light : AppTheme.dark,
      );
}
