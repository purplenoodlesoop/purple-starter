import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

mixin HttpRequester {
  static TaskEither<L, R> request<L, R>(
    Future<Response> Function() requestUnsafe,
    R Function(Response response) parseUnsafe,
    L Function(Object error) onError,
  ) =>
      TaskEither.tryCatch(
        requestUnsafe,
        (error, _) => onError(error),
      ).flatMap(
        (response) => TaskEither.tryCatch(
          () async => parseUnsafe(response),
          (error, _) => onError(error),
        ),
      );

  static TaskEither<L, R> perform<L, R>(
    TaskEither<L, R> Function(Client client) request,
  ) =>
      TaskEither<L, Client>(() async => Either.of(Client())).flatMap(
        (client) => TaskEither.flatten(
          TaskEither<L, Either<L, R>>.fromTask(
            request(client).match<Either<L, R>>((l) {
              client.close();
              return left(l);
            }, (r) {
              client.close();
              return right(r);
            }),
          ).map((either) => TaskEither.fromEither(either)),
        ),
      );
}
