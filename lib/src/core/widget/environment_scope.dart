import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/model/environment_storage.dart';
import 'package:purple_starter/src/core/widget/scope.dart';

class EnvironmentScope extends Scope {
  static const DelegateAccess<_EnvironmentScopeDelegate> _delegateOf =
      Scope.delegateOf<EnvironmentScope, _EnvironmentScopeDelegate>;

  final IEnvironmentStorage Function(BuildContext context) create;

  const EnvironmentScope({
    required this.create,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  static IEnvironmentStorage of(BuildContext context) =>
      _delegateOf(context).storage;

  @override
  ScopeDelegate<EnvironmentScope> createDelegate() =>
      _EnvironmentScopeDelegate();
}

class _EnvironmentScopeDelegate extends ScopeDelegate<EnvironmentScope> {
  late final IEnvironmentStorage storage = widget.create(context);
}
