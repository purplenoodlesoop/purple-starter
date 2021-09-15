import 'package:functional_starter/common/modules/core/matcher.dart';

enum LogLevels {
  info,
  warning,
  error,
}

extension StringExtension on LogLevels {
  String get string => Matcher.match(this, to: {
        LogLevels.info: 'INFO:',
        LogLevels.warning: 'WARNING:',
        LogLevels.error: 'ERROR:'
      });
}
