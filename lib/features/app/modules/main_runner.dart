import 'dart:async';

import 'package:flutter/material.dart';
import 'package:functional_starter/common/modules/io/logger.dart';

mixin MainRunnerModule {
  static Future<void> _onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> run(void Function() app) async {
    await LoggerModule.runLogging(
      () => runZonedGuarded(
        () async {
          await _onInit();
          app();
        },
        LoggerModule.logZoneError,
      ),
    );
  }
}
