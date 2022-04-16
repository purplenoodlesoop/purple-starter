// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/src/core/extension/extensions.dart';
import 'package:purple_starter/src/feature/app/bloc/app_bloc_observer.dart';
import 'package:purple_starter/src/feature/app/logic/logger.dart';
import 'package:purple_starter/src/feature/app/logic/sentry_init.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_bloc/stream_bloc.dart';

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

  static T? _runZoned<T>(T Function() body) => Logger.runLogging(
        () => StreamBlocObserver.inject(
          const AppBlocObserver(),
          () => runZonedGuarded(
            body,
            Logger.logZoneError,
          ),
        ),
      );

  static Future<void> run<D>({
    bool shouldSend = !kDebugMode,
    required AsyncDependencies<D> asyncDependencies,
    required AppBuilder<D> appBuilder,
  }) async {
    await _runZoned(
      () async {
        // ignore: avoid-ignoring-return-values
        WidgetsFlutterBinding.ensureInitialized();
        _amendFlutterError();
        final app = await _initApp(shouldSend, asyncDependencies, appBuilder);
        runApp(
          DefaultAssetBundle(
            bundle: SentryAssetBundle(),
            child: app,
          ),
        );
      },
    );
  }
}
