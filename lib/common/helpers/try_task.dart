import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/models/failure.dart';

TaskEither<Failure, T> tryTask<T>(
  Future<T> Function() f,
) =>
    TaskEither.tryCatch(f, (e, s) => Failure(s, e));
