import 'package:purple_starter/src/feature/app/logic/main_runner.dart';
import 'package:purple_starter/src/feature/app/model/async_app_dependencies.dart';
import 'package:purple_starter/src/feature/app/purple_starter_app.dart';

Future<void> run() => MainRunner.run<AsyncAppDependencies>(
      asyncDependencies: AsyncAppDependencies.obtain,
      appBuilder: (sentrySubscription, dependencies) => PurpleStarterApp(
        sentrySubscription: sentrySubscription,
        sharedPreferences: dependencies.sharedPreferences,
      ),
    );
