import 'package:flutter/foundation.dart';
import 'package:l/l.dart';

extension DriftLogger on Never {
  //driftRuntimeOptions.debugPrint('Drift: Sent $sql with args $args');

  static const bool shouldLog = !kReleaseMode;

  static void log(String string) {
    final parts = string.split('with args');
    final sql = parts.first.split('Drift: Sent').last.trim();
    final args = parts.last.trim();

    l.i('Drift | Executing $sql with $args');
  }
}
