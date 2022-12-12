import 'package:flutter/foundation.dart';
import 'package:l/l.dart';

extension DriftLogger on Never {
  static const bool shouldLog = !kReleaseMode;

  static void log(String string) {
    final parts = string.split('with args');
    final sql = parts.first.split('Drift: Sent').last.trim();
    final args = parts.last.trim();

    final buffer = StringBuffer()
      ..write('DriftLogger | Executing')
      ..write(sql)
      ..write(' with ')
      ..write(args);

    l.i(buffer.toString());
  }
}
