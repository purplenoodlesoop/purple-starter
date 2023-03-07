import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/feature/app/router/logger_navigator_observer.dart';

abstract class AppFeatureDependencies
    implements LoggerNavigationObserverDependencies {}

class AppFeatureModule<P extends SharedParent<P>>
    extends SharedBaseModule<AppFeatureModule<P>, P>
    implements AppFeatureDependencies {
  AppFeatureModule(super.parent);
}
