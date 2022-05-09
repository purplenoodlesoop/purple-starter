import 'package:purple_starter/src/core/enum/environment.dart';

abstract class IEnvironmentStorage {
  Environment get environment;
  String get sentryDsn;
}

class EnvironmentStorage implements IEnvironmentStorage {
  const EnvironmentStorage();

  @override
  Environment get environment => Environment.values.byName(
        const String.fromEnvironment('ENVIRONMENT'),
      );

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
