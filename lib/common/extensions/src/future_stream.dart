import 'dart:async';

extension FutureStreamExtensions<T> on Future<Stream<T>> {
  Stream<T> unwrap() {
    StreamSubscription<T>? subscription;
    StreamController<T>? controller;

    controller = StreamController<T>.broadcast(
      onCancel: () {
        subscription?.cancel();
        controller?.close();
      },
    );

    then((stream) {
      if (controller == null || controller.isClosed) return;
      subscription = stream.listen(
        controller.add,
        onDone: controller.close,
        onError: controller.addError,
      );
    });

    return controller.stream;
  }
}
