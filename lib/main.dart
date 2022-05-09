// ignore: unused_import
import 'package:purple_starter/runner_stub.dart'
    if (dart.library.io) 'package:purple_starter/runner_io.dart'
    if (dart.library.html) 'package:purple_starter/runner_web.dart' as runner;

void main() => runner.run();
