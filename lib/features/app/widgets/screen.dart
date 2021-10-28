import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';
import 'package:objectbox/objectbox.dart';

class NameApp extends StatelessWidget {
  final Store objectBoxStore;
  final Widget child;

  const NameApp({
    Key? key,
    required this.objectBoxStore,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DependenciesProvider(
        obStore: objectBoxStore,
        child: MaterialApp(
          home: child,
        ),
      );
}
