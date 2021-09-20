import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/models/failure.dart';
import 'package:functional_starter/common/modules/io/db/db_path_manager.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

typedef DbCallback<T> = Future<void> Function(
  Database db,
  StoreRef<T, Map<String, Object?>> store,
);

mixin DbAccess {
  static TaskEither<Failure, Unit> perform<T>(
    String dbPath,
    StoreRef<T, Map<String, Object?>> store,
    DbCallback<T> fUnsafe,
  ) =>
      TaskEither.tryCatch(
        () => databaseFactoryIo.openDatabase(dbPath),
        Failure.n,
      ).flatMap(
        // TODO: -- Make client close anyway, using match instead of flatMap
        (db) => TaskEither.tryCatch(
          () => fUnsafe(db, store),
          Failure.n,
        ).flatMap(
          (_) => TaskEither.fromTask(Task(db.close).asUnit()),
        ),
      );

  static TaskEither<Failure, Unit> performDefault(
    String dbName,
    String storeName,
    DbCallback<String> fUnsafe,
  ) =>
      DbPathManager.getPath(dbName).flatMap(
        (dbPath) => perform<String>(
          dbPath,
          stringMapStoreFactory.store(storeName),
          fUnsafe,
        ),
      );

  Stream<List<RecordSnapshot<T, Map<String, Object?>>>> stream<T>(
    String dbPath,
    StoreRef<T, Map<String, Object?>> store, {
    Finder? finder,
  }) async* {
    final db = await databaseFactoryIo.openDatabase(dbPath);

    StreamSubscription<List<RecordSnapshot<T, Map<String, Object?>>>>?
        subscription;
    StreamController<List<RecordSnapshot<T, Map<String, Object?>>>>? controller;

    controller = StreamController(
      onCancel: () {
        subscription?.cancel();
        controller?.close();
        db.close();
      },
    );

    if (!controller.isClosed) {
      subscription = store.query(finder: finder).onSnapshots(db).listen(
            controller.add,
            onDone: controller.close,
            onError: controller.addError,
          );
    }

    yield* controller.stream;
  }

  Stream<List<RecordSnapshot<String, Map<String, Object?>>>> streamDefault(
    String dbName,
    String storeName, {
    Finder? finder,
  }) async* {
    final dbPath = await DbPathManager.getPath(dbName).run();
    if (dbPath is Left<Failure, String>) {
      final failure = dbPath.value;
      yield* Stream.error(failure.exception, failure.stackTrace);
    } else {
      yield* stream<String>(
        (dbPath as Right<Failure, String>).value,
        stringMapStoreFactory.store(storeName),
      );
    }
  }
}
