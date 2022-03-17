import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/common/database/app_database.dart';
import 'package:purple_starter/common/widget/scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAppDependencies {
  Dio get dio;
  AppDatabase get database;
  SharedPreferences get sharedPreferences;
}

class AppDependenciesScope extends Scope {
  static const DelegateAccess<_AppDependenciesScopeDelegate> _delegateOf =
      Scope.delegateOf<AppDependenciesScope, _AppDependenciesScopeDelegate>;

  final String databaseName;
  final SharedPreferences sharedPreferences;

  const AppDependenciesScope({
    required this.databaseName,
    required this.sharedPreferences,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  static IAppDependencies dependenciesOf(
    BuildContext context,
  ) =>
      _delegateOf(context);

  @override
  ScopeDelegate<AppDependenciesScope> createDelegate() =>
      _AppDependenciesScopeDelegate();
}

class _AppDependenciesScopeDelegate extends ScopeDelegate<AppDependenciesScope>
    implements IAppDependencies {
  Dio? _client;
  AppDatabase? _database;

  @override
  Dio get dio => _client ??= Dio();

  @override
  AppDatabase get database => _database ??= AppDatabase(
        name: widget.databaseName,
      );

  @override
  SharedPreferences get sharedPreferences => widget.sharedPreferences;

  Future<void> _closeDependencies() async {
    _client?.close();
    await _database?.close();
  }

  @override
  void dispose() {
    _closeDependencies();
    super.dispose();
  }
}
