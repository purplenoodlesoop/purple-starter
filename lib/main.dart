import 'package:purple_starter/feature/app/module/main_runner.dart';
import 'package:purple_starter/feature/app/purple_app.dart';

Future<void> main() => MainRunner.run(
      // TODO: - Cancel sentry subscription
      app: (sentrySubscription) => const PurpleApp(),
    );
