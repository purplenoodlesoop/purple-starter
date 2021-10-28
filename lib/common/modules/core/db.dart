import 'dart:async';

import 'package:objectbox/internal.dart';
import 'package:objectbox/objectbox.dart';

Stream<List<T>> obStreamQuery<T>(
  Box<T> box, {
  Condition<T>? condition,
  QueryProperty<T, dynamic>? orderBy,
  int? flags,
}) {
  StreamSubscription<Query<T>>? querySubscription;

  final queryStreamController = StreamController<List<T>>.broadcast();

  void onListen() {
    final query = box.query(condition);
    if (orderBy != null) {
      flags == null
          ? query.order<dynamic>(orderBy)
          : query.order<dynamic>(orderBy, flags: flags);
    }
    querySubscription = query.watch().listen(
          (query) => queryStreamController.add(query.find()),
          onDone: queryStreamController.close,
          onError: queryStreamController.addError,
        );
  }

  void onCancel() {
    querySubscription?.cancel();
    queryStreamController.close();
  }

  queryStreamController
    ..onListen = onListen
    ..onCancel = onCancel;

  return queryStreamController.stream;
}
