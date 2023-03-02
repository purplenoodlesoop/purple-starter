import 'package:arbor/arbor.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';

abstract class BootstrapDependencies implements LoggerDependency {}

class BootstrapDependenciesTree extends BaseTree<BootstrapDependenciesTree> {}
