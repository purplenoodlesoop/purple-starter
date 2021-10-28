import 'dart:async';

import 'package:objectbox/internal.dart';
import 'package:objectbox/objectbox.dart';

Stream<List<T>> obStreamQuery<T>(
  Box<T> box, {
  Condition<T>? condition,
  QueryProperty<T, dynamic>? orderBy,
  int? flags,
}) {
  final query = box.query(condition);
  if (orderBy != null) {
    flags == null
        ? query.order<dynamic>(orderBy)
        : query.order<dynamic>(orderBy, flags: flags);
  }
  return query.watch().map((query) => query.find());
}
