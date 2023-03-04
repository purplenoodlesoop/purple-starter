import 'package:purple_starter/src/feature/app/logic/main_runner.dart';
import 'package:purple_starter/src/feature/app/purple_starter_app.dart';

void sharedRun(InitializationHooks initializationHooks) => MainRunner.run(
      appBuilder: (
        initializationData,
        observer,
        logger,
        environmentStorage,
      ) =>
          PurpleStarterApp(
        initializationData: initializationData,
        observer: observer,
        logger: logger,
        environmentStorage: environmentStorage,
      ),
      hooks: initializationHooks,
    );
