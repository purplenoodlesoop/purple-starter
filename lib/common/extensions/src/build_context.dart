import 'package:flutter/material.dart';
import 'package:functional_starter/common/interfaces/app_dependencies.dart';
import 'package:functional_starter/features/app/widgets/dependencies_provider.dart';

extension BuildContextX on BuildContext {
  IAppDependencies get dependencies => AppDependenciesProvider.of(this);
  W? getInheritedWidget<W extends InheritedWidget>({bool listen = false}) {
    if (listen) return dependOnInheritedWidgetOfExactType<W>();
    final widget = getElementForInheritedWidgetOfExactType<W>()?.widget;
    if (widget is W) return widget;
  }
}
