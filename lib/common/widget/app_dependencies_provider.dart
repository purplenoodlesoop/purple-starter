import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/common/database/app_database.dart';

abstract class IAppDependencies {
  Dio get dioClient;
  AppDatabase get database;
}

class AppDependenciesProvider extends StatefulWidget {
  final String databaseName;
  final Widget child;

  const AppDependenciesProvider({
    Key? key,
    required this.databaseName,
    required this.child,
  }) : super(key: key);

  static IAppDependencies of(BuildContext context) =>
      _InheritedAppDependenciesProvider.of(context).providerState;

  @override
  _AppDependenciesProviderState createState() =>
      _AppDependenciesProviderState();
}

class _AppDependenciesProviderState extends State<AppDependenciesProvider>
    implements IAppDependencies {
  Dio? _client;
  AppDatabase? _database;

  @override
  Dio get dioClient => _client ??= Dio();

  @override
  AppDatabase get database => _database ??= AppDatabase(
        name: widget.databaseName,
      );

  Future<void> _closeDependencies() async {
    _client?.close();
    await _database?.close();
  }

  @override
  void dispose() {
    _closeDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedAppDependenciesProvider(
        providerState: this,
        child: widget.child,
      );
}

class _InheritedAppDependenciesProvider extends InheritedWidget {
  final _AppDependenciesProviderState providerState;

  const _InheritedAppDependenciesProvider({
    required this.providerState,
    required Widget child,
  }) : super(child: child);

  static _InheritedAppDependenciesProvider of(BuildContext context) {
    final provider = context.getElementForInheritedWidgetOfExactType<
        _InheritedAppDependenciesProvider>();
    assert(provider != null, "Unable to locate AppDependenciesProvider.");
    return provider!.widget as _InheritedAppDependenciesProvider;
  }

  @override
  bool updateShouldNotify(_InheritedAppDependenciesProvider _) => false;
}
