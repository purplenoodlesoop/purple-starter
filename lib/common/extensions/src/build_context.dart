import 'package:flutter/material.dart';
import 'package:functional_starter/common/interfaces/app_dependencies.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';
import 'package:http/http.dart' as http;

extension BuildContextX on BuildContext {
  IAppDependencies get dependencies => AppDependenciesProvider.of(this);
  http.Client get client => dependencies.httpClient;
}
