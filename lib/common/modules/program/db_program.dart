import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/models/failure.dart';
import 'package:functional_starter/common/modules/io/db/db_access.dart';
import 'package:functional_starter/common/modules/io/db/db_path_manager.dart';
import 'package:sembast/sembast.dart';

mixin DbProgram {
  static StoreRef<String, Map<String, Object?>> _mkStore(
    String name,
  ) =>
      stringMapStoreFactory.store(name);

  static TaskEither<Failure, Unit> perform(
    String dbName,
    String storeName,
    DbCallbackUnsafe<String> f,
  ) =>
      DbPathManager.getPath(dbName).flatMap(
        (dbPath) => DbAccess.perform(dbPath, _mkStore(storeName), f),
      );

  static Stream<List<RecordSnapshot<String, Map<String, Object?>>>>
      streamDefault(
    String dbName,
    String storeName, {
    Finder? finder,
  }) async* {
    final dbPath = await DbPathManager.getPath(dbName).run();
    yield* dbPath.match(
      (failure) => Stream.error(failure.exception, failure.stackTrace),
      (path) => DbAccess.stream(path, _mkStore(storeName)),
    );
  }
}
