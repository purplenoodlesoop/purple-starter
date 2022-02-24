// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/common/extension/extensions.dart';
import 'package:purple_starter/common/module/logger.dart';
import 'package:purple_starter/feature/app/module/sentry_init.dart';

mixin MainRunner {
  static void _amendFlutterError() {
    const log = Logger.logFlutterError;

    FlutterError.onError = FlutterError.onError?.amend(log) ?? log;
  }

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
          _amendFlutterError();
          final sentrySubscription = await SentryInit.init(shouldSend);
          final dependencies = await asyncInit();
          runApp(app(sentrySubscription, dependencies));
        },
        Logger.logZoneError,
      ),
    );
  }
}
