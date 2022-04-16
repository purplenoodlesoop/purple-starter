import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NavigatorObserversFactory {
  const NavigatorObserversFactory();

  List<NavigatorObserver> call() => [
        SentryNavigatorObserver(),
      ];
}
