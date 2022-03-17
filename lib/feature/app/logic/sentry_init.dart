import 'dart:async';

import 'package:l/l.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

typedef SentrySubscription = StreamSubscription<void>;

mixin SentryInit {
  // ignore: no-empty-block, avoid-dynamic
  static void _nothing(dynamic _) {}

  static bool _isWarningOrError(LogMessage message) => message.level.maybeWhen(
        warning: () => true,
        error: () => true,
        orElse: () => false,
      );

  static Stream<LogMessageWithStackTrace> get _warningsAndErrors =>
      l.where(_isWarningOrError).whereType<LogMessageWithStackTrace>();

  static SentrySubscription _subscribeToErrorReporting() => _warningsAndErrors
      .asyncMap(
        (msg) => Sentry.captureException(
          msg.message,
          stackTrace: msg.stackTrace,
        ),
      )
      .listen(_nothing);

  static Future<SentrySubscription> init({required bool shouldSend}) async {
    const dsn = String.fromEnvironment('SENTRY_DSN');
    if (dsn.isNotEmpty && shouldSend) {
      await SentryFlutter.init(
        (options) => options
          ..dsn = dsn
          ..tracesSampleRate = 1,
      );

      return _subscribeToErrorReporting();
    }

    return const Stream<void>.empty().listen(_nothing);
  }
}
