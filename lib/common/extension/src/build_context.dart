import 'package:flutter/material.dart';
import 'package:purple_starter/common/widget/app_dependencies_provider.dart';

extension BuildContextX on BuildContext {
  IAppDependencies get dependencies => AppDependenciesProvider.of(this);
  W? getInheritedWidget<W extends InheritedWidget>({bool listen = false}) {
    if (listen) return dependOnInheritedWidgetOfExactType<W>();
    final widget = getElementForInheritedWidgetOfExactType<W>()?.widget;
    if (widget is W) return widget;
  }
}
