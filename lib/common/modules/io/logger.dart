import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/modules/core/matcher.dart';

enum LogLevels {
  info,
  warning,
  error,
}

extension on LogLevels {
  String get string => Matcher.match(this, to: {
        LogLevels.info: 'INFO:',
        LogLevels.warning: 'WARNING:',
        LogLevels.error: 'ERROR:'
      });
}

typedef LoggerF = IO<Unit> Function(String data, LogLevels level);

mixin Logger {
  static String _assembleLog(
    LogLevels level,
    String data,
    String timestamp,
  ) =>
      '${level.string} $data $timestamp';

  static IO<String> get _timeStamp => dateNow().map((date) => 'at $date');
  static IO<Unit> _ioPrint(String data) => IO(() => print(data)).put(unit);

  static IO<Unit> log(
    String data,
    LogLevels level,
  ) =>
      _timeStamp.map(_assembleLog.curry(level)(data)).flatMap(_ioPrint);
}
