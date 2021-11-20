import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/modules/main_runner.dart';
import 'package:functional_starter/features/app/screen.dart';

Future<void> main() => MainRunnerModule.run(() {
      runApp(const NameApp());
    });
