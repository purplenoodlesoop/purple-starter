import 'package:purple_starter/src/core/di/app_dependencies.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/di/app_feature_dependencies.dart';
import 'package:purple_starter/src/feature/settings/di/settings_dependencies.dart';

class FeatureDependenciesModule<P extends SharedParent<P>>
    extends SharedBaseModule<FeatureDependenciesModule<P>, P>
    implements FeatureDependencies {
  FeatureDependenciesModule(super.parent);

  @override
  AppFeatureDependencies get app =>
      module<AppFeatureModule<FeatureDependenciesModule<P>>>(
        AppFeatureModule.new,
      );

  @override
  SettingsDependencies get settings =>
      module<SettingsDependenciesModule<FeatureDependenciesModule<P>>>(
        SettingsDependenciesModule.new,
      );
}
