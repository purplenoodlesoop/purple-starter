// ignore_for_file: avoid-non-ascii-symbols

import 'package:mark/mark.dart';
import 'package:stack_trace/stack_trace.dart';

extension on DateTime {
  static const int _timeLength = 2;

  static String _formatTime(int input) =>
      input.toString().padLeft(_timeLength, '0');

  String formatted() => [hour, minute, second].map(_formatTime).join(':');
}

class PrettyEphemeralMessageProcessor extends EphemeralMessageProcessor {
  static String _matchEmoji(LogMessage message) => message.matchPrimitive(
        primitive: (message) => message.match(
          error: (_) => '🚫',
          warning: (_) => '⚠️',
          info: (_) => '💡',
          debug: (_) => '🐞',
        ),
        orElse: () => '',
      );

  @override
  String format(LogMessage message) {
    final buffer = StringBuffer()
      ..write(_matchEmoji(message))
      ..write(' ')
      ..write(DateTime.now().formatted())
      ..write(' | ')
      ..write(message);

    if (message.severityValue >= WarningMessage.severity) {
      buffer.write(Trace.from(message.stackTrace).terse);
    }

    return buffer.toString();
  }
}
