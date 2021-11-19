import 'package:flutter/material.dart';
import 'package:l/l.dart';

extension on DateTime {
  String get formatted =>
      [hour, minute, second].map(loggerModule.timeFormat).join(":");
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

class LoggerModule {
  const LoggerModule._internal();
  const factory LoggerModule._() = LoggerModule._internal;

  static const logOptions = LogOptions(
    printColors: false,
    messageFormatting: _formatLoggerMessage,
  );
}

extension XLoggerModule on LoggerModule {
  String timeFormat(int input) => input.toString().padLeft(2, "0");

  static Object _formatLoggerMessage(
    Object message,
    LogLevel logLevel,
    DateTime now,
  ) =>
      "${logLevel.emoji} ${now.formatted} | $message";

  String _formatError(
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

  void logZoneError(
    Object? e,
    StackTrace s,
  ) {
    l.e(_formatError("Top-level", e.toString(), s), s);
  }

  void logFlutterError(
    FlutterErrorDetails details,
  ) {
    final s = details.stack;
    l.e(_formatError("Flutter", details.exceptionAsString(), s), s);
  }
}

const loggerModule = LoggerModule._();
