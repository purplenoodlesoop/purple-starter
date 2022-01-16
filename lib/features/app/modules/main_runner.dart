import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:functional_starter/common/module/logger.dart';
import 'package:functional_starter/features/app/modules/sentry_init.dart';

mixin MainRunner {
  static Future<StreamSubscription<void>> _initApp(bool shouldSend) =>
      SentryInit.init(shouldSend);

  static Future<void> run({
    bool shouldSend = !kDebugMode,
    required Widget Function(StreamSubscription<void> sentrySubscription) app,
  }) async {
    await Logger.runLogging(
      () => runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();
          FlutterError.onError = Logger.logFlutterError;
          runApp(app(await _initApp(shouldSend)));
        },
        Logger.logZoneError,
      ),
    );
  }
}
