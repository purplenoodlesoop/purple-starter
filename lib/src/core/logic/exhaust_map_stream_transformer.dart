// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pure/pure.dart';

typedef ExhaustMapStreamTransformerMapper<A, B> = Stream<B> Function(A event);

@immutable
class ExhaustMapStreamTransformer<A, B> extends StreamTransformerBase<A, B> {
  final ExhaustMapStreamTransformerMapper<A, B> _mapper;

  const ExhaustMapStreamTransformer({
    required ExhaustMapStreamTransformerMapper<A, B> mapper,
  }) : _mapper = mapper;

  @override
  Stream<B> bind(Stream<A> stream) {
    StreamSubscription<B>? mappedSubscription;
    StreamSubscription<A>? sourceSubscription;

    Future<void> manipulateSubscriptions(
      FutureOr<void> Function(StreamSubscription<Object?> subscription) action,
    ) async {
      final perform = action.nullable;
      await perform(mappedSubscription);
      await perform(sourceSubscription);
    }

    void pauseSubscriptions() {
      manipulateSubscriptions((subscription) => subscription.pause());
    }

    void resumeSubscriptions() {
      manipulateSubscriptions((subscription) => subscription.resume());
    }

    final controller = stream.isBroadcast
        ? StreamController<B>.broadcast(sync: true)
        : StreamController<B>(
            onPause: pauseSubscriptions,
            onResume: resumeSubscriptions,
            sync: true,
          );

    Future<void> cancelSubscriptions() => manipulateSubscriptions(
          (subscription) => subscription.cancel(),
        );

    void forgetMappedSubscription() {
      mappedSubscription?.cancel();
      mappedSubscription = null;
    }

    void wrapUp() {
      cancelSubscriptions().whenComplete(controller.close);
    }

    void startListening() {
      final addError = controller.addError;

      sourceSubscription = stream.listen(
        (event) {
          mappedSubscription ??= _mapper(event).listen(
            controller.add,
            onError: addError,
            onDone: forgetMappedSubscription,
          );
        },
        onError: addError,
        onDone: wrapUp,
      );
    }

    controller
      ..onListen = startListening
      ..onCancel = cancelSubscriptions;

    return controller.stream;
  }
}
