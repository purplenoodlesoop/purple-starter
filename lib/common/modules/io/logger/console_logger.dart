import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/modules/io/logger/levels.dart';

mixin ConsoleLogger {
  static String _assembleLog(
    LogLevels level,
    String data,
    String timestamp,
  ) =>
      '${level.string} $data $timestamp';

  static IO<String> get _timeStamp => dateNow().map((date) => 'at $date');
  static IO<Unit> _ioPrint(String data) => IO(() => print(data)).asUnit();

  static IO<Unit> log(
    String data,
    LogLevels level,
  ) =>
      _timeStamp.map(_assembleLog.curry(level)(data)).flatMap(_ioPrint);
}
