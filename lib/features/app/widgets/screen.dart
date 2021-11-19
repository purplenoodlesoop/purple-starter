import 'package:flutter/material.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';

class NameApp extends StatelessWidget {
  final Widget child;

  const NameApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DependenciesProvider(
        child: MaterialApp(
          home: child,
        ),
      );
}
