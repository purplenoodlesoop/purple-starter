abstract class IEnvironmentStorage {
  String get sentryDsn;
}

class EnvironmentStorage implements IEnvironmentStorage {
  const EnvironmentStorage();

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
