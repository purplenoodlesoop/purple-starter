import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';

mixin Navigation {
  static final globalKey = GlobalKey<NavigatorState>();

  static IO<Unit> back<T extends Object?>([T? value]) =>
      IO(() => globalKey.currentState!.pop(value)).put(unit);

  static Task<Unit> to(Widget Function() screen) => Task(
        () => globalKey.currentState!.push(
          MaterialPageRoute<void>(builder: (context) => screen()),
        ),
      ).put(unit);

  static IO<Unit> snack({
    required Widget contents,
    MaterialColor color = Colors.grey,
  }) =>
      IO(
        () => ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: contents,
            backgroundColor: color,
          ),
        ),
      ).put(unit);
}
