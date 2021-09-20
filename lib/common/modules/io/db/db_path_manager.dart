import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/models/failure.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pure/pure.dart';

mixin DbPathManager {
  static Future<String> _createPathUnsafe(String dbName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    await documentsDirectory.create(recursive: true);
    return join(documentsDirectory.path, '$dbName.db');
  }

  static final _createPathUnsafeMemoized = _createPathUnsafe.memoized;

  static TaskEither<Failure, String> getPath(String dbName) =>
      TaskEither<Failure, String>.tryCatch(
        () => _createPathUnsafeMemoized(dbName),
        Failure.n,
      );
}
