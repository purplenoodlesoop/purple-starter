import 'package:functional_starter/common/modules/core/db.dart' as db;
import 'package:objectbox/internal.dart';
import 'package:objectbox/objectbox.dart';

extension StreamQuery<T> on Box<T> {
  Stream<List<T>> streamQuery({
    Condition<T>? condition,
    QueryProperty<T, dynamic>? orderBy,
    int? flags,
  }) =>
      db.obStreamQuery(
        this,
        condition: condition,
        orderBy: orderBy,
        flags: flags,
      );
}
