import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/widget/scope.dart';
import 'package:purple_starter/src/feature/app/logic/sentry_init.dart';

class AppLifecycleScope extends Scope {
  static const DelegateAccess<_AppLifecycleScopeDelegate> _delegateOf =
      Scope.delegateOf<AppLifecycleScope, _AppLifecycleScopeDelegate>;

  final SentrySubscription sentrySubscription;

  const AppLifecycleScope({
    required this.sentrySubscription,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  ScopeDelegate<AppLifecycleScope> createDelegate() =>
      _AppLifecycleScopeDelegate();
}

class _AppLifecycleScopeDelegate extends ScopeDelegate<AppLifecycleScope> {
  Future<void> _cancelSentrySubscription() async {
    await widget.sentrySubscription.cancel();
  }

  @override
  void dispose() {
    _cancelSentrySubscription();
    super.dispose();
  }
}
