import 'package:l/l.dart';

mixin IdentityLoggingMixin on Object {
  void logData(void Function(StringBuffer b) assemble) {
    final buffer = StringBuffer(runtimeType)..write(' | ');
    assemble(buffer);
    l.i(buffer);
  }

  void log(Object? data) {
    logData((b) => b.write(data));
  }
}
