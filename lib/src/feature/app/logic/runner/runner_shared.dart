import 'package:purple_starter/src/feature/app/logic/main_runner.dart';
import 'package:purple_starter/src/feature/app/purple_starter_app.dart';

void sharedRun(InitializationHooks initializationHooks) => MainRunner.run(
      appBuilder: (
        initializationData,
        observer,
        logger,
        configurationRepository,
      ) =>
          PurpleStarterApp(
        initializationData: initializationData,
        observer: observer,
        logger: logger,
        configurationRepository: configurationRepository,
      ),
      hooks: initializationHooks,
    );
