import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:purple_starter/src/feature/settings/database/settings_dao.dart';
import 'package:purple_starter/src/feature/settings/repository/settings_repository.dart';

abstract class SettingsDependencies implements SettingsBlocDependencies {}

class SettingsDependenciesModule<P extends SharedParent<P>>
    extends SharedBaseModule<SettingsDependenciesModule<P>, P>
    implements SettingsDependencies, SettingsRepositoryDependencies {
  SettingsDependenciesModule(super.parent);

  @override
  ISettingsDao get settingsDao => shared(
        () => SettingsDao(preferencesDriver),
      );

  @override
  ISettingsRepository get settingsRepository => shared(
        () => SettingsRepository(this),
      );
}
