import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/enum/environment.dart';

abstract class IEnvironmentStorage {
  Environment get environment;
  String get sentryDsn;
}

abstract class EnvironmentStorageDependency {
  IEnvironmentStorage get environmentStorage;
}

class EnvironmentStorage implements IEnvironmentStorage {
  const EnvironmentStorage();

  @override
  Environment get environment => const String.fromEnvironment('ENVIRONMENT')
      .pipe(Environment.values.byName);

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
