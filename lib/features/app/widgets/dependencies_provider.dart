import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DependenciesProvider extends StatefulWidget {
  final Widget child;

  const DependenciesProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  static const _stateOf = _DependenciesProviderState.of;

  static http.Client httpClientOf(BuildContext context) =>
      _stateOf(context).getClient();

  @override
  _DependenciesProviderState createState() => _DependenciesProviderState();
}

class _DependenciesProviderState extends State<DependenciesProvider> {
  http.Client? _client;

  http.Client getClient() => _client ??= http.Client();

  static _DependenciesProviderState of(BuildContext context) =>
      _InheriteDependenciesProvider.of(context).providerState;

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheriteDependenciesProvider(
        providerState: this,
        child: widget.child,
      );
}

class _InheriteDependenciesProvider extends InheritedWidget {
  final _DependenciesProviderState providerState;

  const _InheriteDependenciesProvider({
    required this.providerState,
    required Widget child,
  }) : super(child: child);

  static _InheriteDependenciesProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_InheriteDependenciesProvider>();
    assert(provider != null, "Unable to locate DependenciesProvider.");
    return provider!;
  }

  @override
  bool updateShouldNotify(_InheriteDependenciesProvider _) => false;
}
