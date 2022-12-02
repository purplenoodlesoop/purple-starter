import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class IRepositoryStorage {
  ISettingsRepository get settings;
}

class RepositoryStorage implements IRepositoryStorage {
  final AppDatabase _appDatabase;
  final PreferencesDriver _preferencesDriver;

  RepositoryStorage({
    required AppDatabase appDatabase,
    required PreferencesDriver preferencesDriver,
  })  : _appDatabase = appDatabase,
        _preferencesDriver = preferencesDriver;

  @override
  ISettingsRepository get settings => SettingsRepository(
        settingsDao: SettingsDao(_preferencesDriver),
      );
}
