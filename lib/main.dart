import 'package:flutter/material.dart';
import 'package:purple_starter/feature/app/module/main_runner.dart';
import 'package:purple_starter/feature/app/purple_starter_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class _AsyncDependencies {
  final SharedPreferences sharedPreferences;

  const _AsyncDependencies(this.sharedPreferences);

  static Future<_AsyncDependencies> obtain() async => _AsyncDependencies(
        await SharedPreferences.getInstance(),
      );
}

Future<void> main() => MainRunner.run<_AsyncDependencies>(
      asyncInit: _AsyncDependencies.obtain,
      app: (sentrySubscription, dependencies) => PurpleStarterApp(
        sharedPreferences: dependencies.sharedPreferences,
      ),
    );
