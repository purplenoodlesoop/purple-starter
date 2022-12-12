import 'package:purple_starter/src/feature/app/logic/runner/runner_stub.dart'
    if (dart.library.io) 'package:purple_starter/src/feature/app/logic/runner/runner_io.dart'
    if (dart.library.html) 'package:purple_starter/src/feature/app/logic/runner/runner_web.dart'
    as runner;

void main() => runner.run();
