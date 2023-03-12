import 'package:arbor/arbor.dart';
import 'package:dio/dio.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/core/repository/configuration_repository.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class LoggerDependency {
  Logger get logger;
}

abstract class DatabaseDependency {
  AppDatabase get database;
}

abstract class DioDependency {
  Dio get dio;
}

abstract class SharedParent<P extends SharedParent<P>>
    implements
        Node<P>,
        LoggerDependency,
        DatabaseDependency,
        DioDependency,
        ConfigurationRepositoryDependency {
  PreferencesDriver get preferencesDriver;
}

mixin SharedParentNodeMixin<C extends SharedParentNodeMixin<C, P>,
    P extends SharedParent<P>> on HasParent<P> implements SharedParent<C> {
  @override
  Logger get logger => parent.logger;

  @override
  AppDatabase get database => parent.database;

  @override
  Dio get dio => parent.dio;

  @override
  PreferencesDriver get preferencesDriver => parent.preferencesDriver;

  @override
  IConfigurationRepository get configurationRepository =>
      parent.configurationRepository;
}

abstract class SharedBaseChildNode<C extends SharedBaseChildNode<C, P>,
        P extends SharedParent<P>> = BaseChildNode<C, P>
    with SharedParentNodeMixin<C, P>;

abstract class SharedBaseModule<C extends SharedBaseModule<C, P>,
        P extends SharedParent<P>> = BaseModule<C, P>
    with SharedParentNodeMixin<C, P>;
