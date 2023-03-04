import 'dart:async';

import 'package:mark/mark.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorReportingMessageProcessor
    extends BaseMessageProcessor<LogMessage, LogMessage>
    with IdentityMessageFormatterMixin<LogMessage> {
  @override
  bool allow(LogMessage message) =>
      message.severityValue >= WarningMessage.severity;

  @override
  Future<void> process(LogMessage message, LogMessage formattedMessage) =>
      Sentry.captureException(
        message.data,
        stackTrace: message.stackTrace,
      );
}
