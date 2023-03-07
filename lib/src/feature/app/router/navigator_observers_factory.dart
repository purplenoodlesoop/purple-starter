import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

List<NavigatorObserver> createNavigatorObservers() => [
      SentryNavigatorObserver(),
    ];
