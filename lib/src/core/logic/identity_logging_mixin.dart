import 'package:mark/mark.dart';

mixin IdentityLoggingMixin on Object {
  Logger get logger;

  void logData(void Function(StringBuffer b) assemble) {
    final buffer = StringBuffer(runtimeType)..write(' | ');
    assemble(buffer);
    logger.info(buffer);
  }

  void log(Object? data) {
    logData((b) => b.write(data));
  }
}
