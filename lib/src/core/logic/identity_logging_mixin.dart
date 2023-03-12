import 'package:mark/mark.dart';

mixin IdentityLoggingMixin on Object {
  Logger get logger;

  bool get shouldLog => true;

  late final String _name = runtimeType.toString();

  void log(void Function(StringBuffer b) assemble) {
    if (shouldLog) {
      final buffer = StringBuffer(_name)..write(' | ');
      assemble(buffer);
      logger.info(buffer);
    }
  }

  void logData(Object? data) {
    if (shouldLog) log((b) => b.write(data));
  }
}
