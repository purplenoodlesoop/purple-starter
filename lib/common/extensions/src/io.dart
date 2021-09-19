import 'package:fpdart/fpdart.dart';

extension IOExtensions<A> on IO<A> {
  IO<B> put<B>(B b) => map((_) => b);
  IO<A> performDiscardIO(IO<Object?> io) => flatMap((a) => io.map((_) => a));
}

extension ToUnitIO on IO<void> {
  IO<Unit> asUnit() => put(unit);
}
