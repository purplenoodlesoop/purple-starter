import 'package:arbor/arbor.dart';
import 'package:flutter/foundation.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';

abstract class AppArborObserverDependencies implements LoggerDependency {}

class AppArborObserver with IdentityLoggingMixin implements ArborObserver {
  @override
  final Logger logger;

  AppArborObserver(this.logger);

  @override
  bool get shouldLog => kDebugMode;

  @override
  void onCreatedChild<A extends Node<A>>(ChildNode node) {
    log(
      (b) => b
        ..write(A)
        ..write(' created child ')
        ..write(node.runtimeType),
    );
  }

  @override
  void onCreatedModule<A extends Node<A>>(ModuleNode module) {
    log(
      (b) => b
        ..write(A)
        ..write(' created module ')
        ..write(module.runtimeType),
    );
  }

  @override
  void onCreatedInstance<A extends Node<A>>(Object? object) {
    log(
      (b) => b
        ..write(A)
        ..write(' created new ')
        ..write(object.runtimeType),
    );
  }

  @override
  void onCreatedShared<A extends Node<A>>(Object? object) {
    log(
      (b) => b
        ..write(A)
        ..write(' created shared ')
        ..write(object.runtimeType),
    );
  }

  @override
  void onInit<A extends Lifecycle>() {
    log(
      (b) => b
        ..write('Init ')
        ..write(A),
    );
  }

  @override
  void onDisposed<A extends Disposable>() {
    log(
      (b) => b
        ..write('Disposed ')
        ..write(A),
    );
  }
}
