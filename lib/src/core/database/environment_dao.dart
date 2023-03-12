import 'package:pure/pure.dart';
import 'package:purple_starter/src/core/enum/environment.dart';

abstract class IEnvironmentDao {
  Environment get environment;
  String get sentryDsn;
}

abstract class EnvironmentDaoDependency {
  IEnvironmentDao get environmentDao;
}

class EnvironmentDao implements IEnvironmentDao {
  const EnvironmentDao();

  @override
  Environment get environment => const String.fromEnvironment('ENVIRONMENT')
      .pipe(Environment.values.byName);

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
