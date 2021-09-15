import 'package:fpdart/fpdart.dart';

extension TaskExtensions<A> on Task<A> {
  Task<A> performDiscardIO(IO<Object?> io) =>
      flatMap((a) => io.map((_) => a).toTask());
  Task<B> put<B>(B b) => map((_) => b);
}
