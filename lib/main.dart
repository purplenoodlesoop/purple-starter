import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/screen.dart';
import 'package:objectbox/objectbox.dart';
import 'package:functional_starter/objectbox.g.dart';

@Entity()
class _DummyEntity {
  int id;
  _DummyEntity(this.id);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await openStore();

  runApp(NameApp(
    objectBoxStore: store,
    child: Container(),
  ));
}
