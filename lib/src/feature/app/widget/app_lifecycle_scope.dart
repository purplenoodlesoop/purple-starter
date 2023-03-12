import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/widget/scope.dart';

class AppLifecycleScope extends Scope {
  static const DelegateAccess<_AppLifecycleScopeDelegate> _delegateOf =
      Scope.delegateOf<AppLifecycleScope, _AppLifecycleScopeDelegate>;

  const AppLifecycleScope({
    required super.child,
    super.key,
  });

  @override
  ScopeDelegate<AppLifecycleScope> createDelegate() =>
      _AppLifecycleScopeDelegate();
}

class _AppLifecycleScopeDelegate extends ScopeDelegate<AppLifecycleScope>
    with WidgetsBindingObserver {
  void onResumed() {}

  void onInactive() {}

  void onPaused() {}

  void onDetached() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }
}
