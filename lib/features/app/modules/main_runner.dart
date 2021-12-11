import 'dart:async';

import 'package:flutter/material.dart';
import 'package:functional_starter/common/modules/logger.dart';

mixin MainRunnerM {
  static Future<void> _onInit() async {}

  static Future<void> run(Widget Function() app) async {
    await LoggerM.runLogging(
      () => runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();
          FlutterError.onError = LoggerM.logFlutterError;
          await _onInit();
          runApp(app());
        },
        LoggerM.logZoneError,
      ),
    );
  }
}
