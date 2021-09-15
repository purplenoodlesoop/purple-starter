import 'package:fpdart/fpdart.dart';

extension TaskExtensions<A> on Task<A> {
  Task<A> performDiscardIO(IO<Object?> io) =>
      flatMap((a) => io.map((_) => a).toTask());
}
