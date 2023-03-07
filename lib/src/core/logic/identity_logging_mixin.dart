import 'package:mark/mark.dart';

mixin IdentityLoggingMixin on Object {
  Logger get logger;

  void log(void Function(StringBuffer b) assemble) {
    final buffer = StringBuffer(runtimeType)..write(' | ');
    assemble(buffer);
    logger.info(buffer);
  }

  void logData(Object? data) {
    log((b) => b.write(data));
  }
}
