import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef DelegateAccess<D extends ScopeDelegate> = D Function(
  BuildContext, {
  bool listen,
});

/// A base class for all Scopes that makes InheritedWidgets easier to use and
/// more reusable.
///
/// To create a custom scope, concrete class that extends [Scope] must override
/// abstract [createDelegate] method.
abstract class Scope extends StatefulWidget {
  final Widget _child;

  const Scope({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  /// Accesses a delegate of a given scope through InheritedWidget location,
  /// thus making this method having complexity of O(1).
  static D delegateOf<S extends Scope, D extends ScopeDelegate<S>>(
    BuildContext context, {
    bool listen = false,
  }) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedScope<S>>()
        : context
            .getElementForInheritedWidgetOfExactType<InheritedScope<S>>()
            ?.widget as InheritedScope<S>?;
    assert(
      scope != null,
      "Unable to locate $D of $S. Either it was not declared as an ancestor "
      "of the widget that has tried to access it, or BuildContext does not "
      "contain its instance.",
    );

    return scope!.delegate as D;
  }

  /// Create a delegate of this Scope.
  ///
  /// Similar to [createState] method of [StatefulWidget].
  ScopeDelegate<Scope> createDelegate();

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => createDelegate();
}

/// Mutable delegate of a Scope.
///
/// Similar to [State] of [StatefulWidget].
///
/// There are a few difference between [State] and [ScopeDelegate] classes:
///   * [ScopeDelegate] has [keys] getter that indicates whether or not a
/// dependant [Element] should be marked as dirty.
///   * [ScopeDelegate] has [scope] getter that allows accessing the delegating
/// [Scope].
///   * [ScopeDelegate] has [buildScoping] method that should be overriden
/// instead of the [build] method. Class that extends [ScopeDelegate] should
/// **NEVER OVERRIDE THE BUILD METHOD**. It will break things.
abstract class ScopeDelegate<S extends Scope> extends State<S> {
  List<Object?> get keys => const [];

  Widget buildScoping(BuildContext context, Widget child) => child;

  S get scope => widget;

  @override
  Widget build(BuildContext context) => InheritedScope<S>(
        delegate: this,
        child: buildScoping(context, widget._child),
      );
}

class InheritedScope<S extends Scope> extends InheritedWidget {
  final List<Object?> keys;
  final ScopeDelegate<Scope> delegate;

  InheritedScope({
    Key? key,
    required this.delegate,
    required Widget child,
  })  : keys = delegate.keys,
        super(child: child, key: key);

  @override
  bool updateShouldNotify(InheritedScope<S> oldWidget) =>
      !const DeepCollectionEquality().equals(keys, oldWidget.keys);
}
