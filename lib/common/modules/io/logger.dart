import 'package:flutter/material.dart';
import 'package:l/l.dart';

extension on DateTime {
  String get formatted =>
      [hour, minute, second].map(LoggerModule._timeFormat).join(":");
}

extension on LogLevel {
  String get emoji => maybeWhen(
        shout: () => "❗️",
        error: () => "🚫",
        warning: () => "⚠️",
        info: () => "💡",
        debug: () => "🐞",
        orElse: () => "",
      );
}

mixin LoggerModule {
  static const _logOptions = LogOptions(
    printColors: false,
    messageFormatting: _formatLoggerMessage,
  );

  static String _timeFormat(int input) => input.toString().padLeft(2, "0");

  static Object _formatLoggerMessage(
    Object message,
    LogLevel logLevel,
    DateTime now,
  ) =>
      "${logLevel.emoji} ${now.formatted} | $message";

  static String _formatError(
    String type,
    String error,
    StackTrace? stackTrace,
  ) {
    final buffer = StringBuffer(type)
      ..write(" ")
      ..write("error")
      ..write(": ")
      ..write(error)
      ..writeln()
      ..writeln("Stack trace:")
      ..write(stackTrace);
    return buffer.toString();
  }

  static void logZoneError(
    Object? e,
    StackTrace s,
  ) {
    l.e(_formatError("Top-level", e.toString(), s), s);
  }

  static void logFlutterError(
    FlutterErrorDetails details,
  ) {
    final s = details.stack;
    l.e(_formatError("Flutter", details.exceptionAsString(), s), s);
  }

  static T runLogging<T>(T Function() body) => l.capture(body, _logOptions);
}
