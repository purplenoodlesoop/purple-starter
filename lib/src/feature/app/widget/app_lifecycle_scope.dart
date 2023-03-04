import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/widget/scope.dart';

class AppLifecycleScope extends Scope {
  static const DelegateAccess<_AppLifecycleScopeDelegate> _delegateOf =
      Scope.delegateOf<AppLifecycleScope, _AppLifecycleScopeDelegate>;

  const AppLifecycleScope({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  ScopeDelegate<AppLifecycleScope> createDelegate() =>
      _AppLifecycleScopeDelegate();
}

class _AppLifecycleScopeDelegate extends ScopeDelegate<AppLifecycleScope> {}
