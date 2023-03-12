import 'package:purple_starter/src/core/database/environment_dao.dart';
import 'package:purple_starter/src/core/enum/environment.dart';

abstract class IConfigurationRepository {
  Environment get environment;
  String get sentryDsn;
}

abstract class ConfigurationRepositoryDependency {
  IConfigurationRepository get configurationRepository;
}

abstract class ConfigurationRepositoryDependencies
    implements EnvironmentDaoDependency {}

class ConfigurationRepository implements IConfigurationRepository {
  final ConfigurationRepositoryDependencies _dependencies;

  const ConfigurationRepository(this._dependencies);

  @override
  Environment get environment => _dependencies.environmentDao.environment;

  @override
  String get sentryDsn => _dependencies.environmentDao.sentryDsn;
}
