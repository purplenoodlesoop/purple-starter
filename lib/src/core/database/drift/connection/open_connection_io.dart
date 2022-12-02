import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:purple_starter/src/feature/app/database/drift_logger.dart';

QueryExecutor openConnection(String name) => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, '$name.sqlite'));

      return NativeDatabase(file, logStatements: DriftLogger.shouldLog);
    });
