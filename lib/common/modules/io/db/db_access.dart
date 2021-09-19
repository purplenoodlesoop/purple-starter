import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/modules/io/db/db_path_manager.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

typedef DbCallback<T> = Task<Unit> Function(
  Database db,
  StoreRef<T, Map<String, Object?>> store,
);

mixin DbAccess {
  static Task<Unit> perform<T>(
    String dbPath,
    StoreRef<T, Map<String, Object?>> store,
    DbCallback<T> f,
  ) =>
      Task(() => databaseFactoryIo.openDatabase(dbPath)).flatMap(
        (db) => f(db, store).flatMap((_) => Task(db.close).asUnit()),
      );

  static Task<Unit> performDefault(
    String dbName,
    String storeName,
    DbCallback<String> f,
  ) =>
      DbPathManager.getPath(dbName).flatMap(
        (dbPath) => perform<String>(
          dbPath,
          stringMapStoreFactory.store(storeName),
          f,
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
    yield* stream<String>(dbPath, stringMapStoreFactory.store(storeName));
  }
}
