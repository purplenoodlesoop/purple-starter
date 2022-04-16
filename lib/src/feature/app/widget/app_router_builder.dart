import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:purple_starter/src/feature/app/router/navigator_observers_factory.dart';

typedef CreateRouter = RootStackRouter Function(BuildContext context);
typedef RouterWidgetBuilder = Widget Function(
  BuildContext context,
  RouteInformationParser<UrlState> informationParser,
  RouterDelegate<UrlState> routerDelegate,
);

class AppRouterBuilder extends StatefulWidget {
  final CreateRouter createRouter;
  final RouterWidgetBuilder builder;

  const AppRouterBuilder({
    Key? key,
    required this.createRouter,
    required this.builder,
  }) : super(key: key);

  @override
  State<AppRouterBuilder> createState() => _AppRouterBuilderState();
}

class _AppRouterBuilderState extends State<AppRouterBuilder> {
  late final RootStackRouter router = widget.createRouter(context);

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        router.defaultRouteParser(),
        router.delegate(
          navigatorObservers: const NavigatorObserversFactory(),
        ),
      );
}
