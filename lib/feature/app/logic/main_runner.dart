// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/common/extension/extensions.dart';
import 'package:purple_starter/feature/app/logic/logger.dart';
import 'package:purple_starter/feature/app/logic/sentry_init.dart';

typedef AsyncDependencies<D> = Future<D> Function();
typedef AppBuilder<D> = Widget Function(
  SentrySubscription sentrySubscription,
  D dependencies,
);

mixin MainRunner {
  static void _amendFlutterError() {
    const log = Logger.logFlutterError;

    FlutterError.onError = FlutterError.onError?.amend(log) ?? log;
  }

  static Future<Widget> _initApp<D>(
    bool shouldSend,
    AsyncDependencies<D> asyncDependencies,
    AppBuilder<D> app,
  ) async {
    final sentrySubscription = await SentryInit.init(shouldSend: shouldSend);
    final dependencies = await asyncDependencies();

    return app(sentrySubscription, dependencies);
  }

  static Future<void> run<D>({
    bool shouldSend = !kDebugMode,
    required AsyncDependencies<D> asyncDependencies,
    required AppBuilder<D> appBuilder,
  }) async {
    await Logger.runLogging(
      () => runZonedGuarded(
        () async {
          // ignore: avoid-ignoring-return-values
          WidgetsFlutterBinding.ensureInitialized();
          _amendFlutterError();
          final app = await _initApp(shouldSend, asyncDependencies, appBuilder);
          runApp(app);
        },
        Logger.logZoneError,
      ),
    );
  }
}
