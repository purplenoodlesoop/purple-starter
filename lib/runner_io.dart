import 'package:purple_starter/runner_shared.dart' as runner;
import 'package:purple_starter/src/feature/app/logic/main_runner.dart';

class IoInitializationHooks extends InitializationHooks {
  const IoInitializationHooks();
}

void run() => runner.sharedRun(const IoInitializationHooks());
