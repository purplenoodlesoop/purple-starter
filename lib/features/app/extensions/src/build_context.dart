import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';
import 'package:http/http.dart' as http;
import 'package:objectbox/objectbox.dart' as ob;

extension BuildContextAppExtensions on BuildContext {
  http.Client get httpClient => DependenciesProvider.httpClientOf(this);
  ob.Store get obStore => DependenciesProvider.obStoreOf(this);
}
