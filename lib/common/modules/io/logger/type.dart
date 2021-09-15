import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/modules/io/logger/levels.dart';

typedef LoggerF = IO<Unit> Function(String data, LogLevels level);
