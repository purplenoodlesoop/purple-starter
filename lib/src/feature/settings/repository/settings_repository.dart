import 'package:pure/pure.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/src/feature/settings/model/settings_data.dart';

abstract class ISettingsRepository {
  SettingsData currentData();

  Future<void> setTheme(AppTheme value);
}

abstract class SettingsRepositoryDependency {
  ISettingsRepository get settingsRepository;
}

abstract class SettingsRepositoryDependencies implements SettingsDaoDependency {
}

class SettingsRepository implements ISettingsRepository {
  final SettingsRepositoryDependencies _dependencies;

  SettingsRepository(this._dependencies);

  AppTheme? get _theme => AppTheme.values.byName.nullable(
        _dependencies.settingsDao.themeMode.value,
      );

  @override
  SettingsData currentData() => SettingsData(
        theme: _theme ?? AppTheme.system,
      );

  @override
  Future<void> setTheme(AppTheme value) =>
      _dependencies.settingsDao.themeMode.setValue(value.name);
}
