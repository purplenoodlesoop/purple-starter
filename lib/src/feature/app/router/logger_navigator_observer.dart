// ignore_for_file: avoid-dynamic

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';

abstract class LoggerNavigationObserverDependencies
    implements LoggerDependency {}

extension on StringBuffer {
  void writeRouteName(Route<dynamic> route) {
    write(route.settings.name);
  }
}

class LoggerNavigationObserver extends AutoRouterObserver
    with IdentityLoggingMixin {
  final LoggerNavigationObserverDependencies _dependencies;

  LoggerNavigationObserver(this._dependencies);

  @override
  Logger get logger => _dependencies.logger;

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    log(
      (b) => b
        ..write('Changed tab route ')
        ..write(previousRoute.name)
        ..write(' -> ')
        ..write(route.name),
    );
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    log(
      (b) => b
        ..write('Initialized tab route ')
        ..write(route.name),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log((b) {
      b
        ..write('Popped route ')
        ..writeRouteName(route);
      if (previousRoute != null) {
        b
          ..write(' -> ')
          ..writeRouteName(previousRoute);
      }
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log((b) {
      b.write('Pushed route ');
      if (previousRoute != null) {
        b
          ..writeRouteName(previousRoute)
          ..write(' -> ');
      }
      b.writeRouteName(route);
    });
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log((b) {
      b
        ..write('Removed route ')
        ..writeRouteName(route);
      if (previousRoute != null) {
        b
          ..write(' -> ')
          ..writeRouteName(previousRoute);
      }
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log((b) {
      b.write('Replaced');
      if (oldRoute != null) {
        b
          ..write(' ')
          ..writeRouteName(oldRoute);
      }
      if (newRoute != null) {
        b
          ..write(' with ')
          ..writeRouteName(newRoute);
      }
    });
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    log((b) {
      b.write('Started user gesture');
      if (previousRoute != null) {
        b
          ..write(' from ')
          ..writeRouteName(previousRoute);
      }
      b
        ..write(' to ')
        ..writeRouteName(route);
    });
  }

  @override
  void didStopUserGesture() {
    logData('Stopped user gesture');
  }
}
