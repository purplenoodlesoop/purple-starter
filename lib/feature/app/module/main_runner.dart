import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/common/module/logger.dart';
import 'package:purple_starter/feature/app/module/sentry_init.dart';

mixin MainRunner {
  static Future<void> run<D>({
    bool shouldSend = !kDebugMode,
    required Future<D> Function() asyncInit,
    required Widget Function(
      StreamSubscription<void> sentrySubscription,
      D dependencies,
    )
        app,
  }) async {
    await Logger.runLogging(
      () => runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();
          FlutterError.onError = Logger.logFlutterError;
          // ignore: cancel_subscriptions
          final sentrySubscription = await SentryInit.init(shouldSend);
          final dependencies = await asyncInit();
          runApp(app(sentrySubscription, dependencies));
        },
        Logger.logZoneError,
      ),
    );
  }
}
