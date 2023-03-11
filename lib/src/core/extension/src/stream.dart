import 'package:purple_starter/src/core/logic/exhaust_map_stream_transformer.dart';

extension StreamX<A> on Stream<A> {
  Stream<B> exhaustMap<B>(ExhaustMapStreamTransformerMapper<A, B> mapper) =>
      transform(
        ExhaustMapStreamTransformer(
          mapper: mapper,
        ),
      );
}
