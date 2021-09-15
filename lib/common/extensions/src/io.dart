import 'package:fpdart/fpdart.dart';

extension IOExtensions<A> on IO<A> {
  IO<B> put<B>(B b) => map((_) => b);
}
