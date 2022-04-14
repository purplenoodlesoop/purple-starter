import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute<void>(page: PlaceholderPage, initial: true),
  ],
)
class AppRouter extends _$AppRouter {}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Placeholder page'),
        ),
      );
}
