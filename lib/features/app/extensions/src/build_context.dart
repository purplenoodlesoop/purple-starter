import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';
import 'package:http/http.dart' as http;

extension BuildContextAppExtensions on BuildContext {
  http.Client get httpClient => DependenciesProvider.httpClientOf(this);
}
