import 'package:arbor/arbor.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';

abstract class AppArborObserverDependencies implements LoggerDependency {}

class AppArborObserver with IdentityLoggingMixin implements ArborObserver {
  final AppArborObserverDependencies _dependencies;

  AppArborObserver(this._dependencies);

  @override
  Logger get logger => _dependencies.logger;

  @override
  void onCreatedChild<A extends Node<A>>(ChildNode node) {
    logData(
      (b) => b
        ..write(A)
        ..write(' created child ')
        ..write(node.runtimeType),
    );
  }

  @override
  void onCreatedModule<A extends Node<A>>(ModuleNode module) {
    logData(
      (b) => b
        ..write(A)
        ..write(' created module '),
    );
  }

  @override
  void onCreatedInstance<A extends Node<A>>(Object? object) {
    logData(
      (b) => b
        ..write(A)
        ..write(' created new ')
        ..write(object.runtimeType),
    );
  }

  @override
  void onCreatedShared<A extends Node<A>>(Object? object) {
    logData(
      (b) => b
        ..write(A)
        ..write(' created shared ')
        ..write(object.runtimeType),
    );
  }

  @override
  void onInit<A extends Lifecycle>() {
    logData(
      (b) => b
        ..write('Init ')
        ..write(A),
    );
  }

  @override
  void onDisposed<A extends Disposable>() {
    logData(
      (b) => b
        ..write('Disposed ')
        ..write(A),
    );
  }
}
