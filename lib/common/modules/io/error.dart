import 'dart:async';

import 'package:l/l.dart';

class ErrorModule {
  const ErrorModule._internal();
  const factory ErrorModule._() = ErrorModule._internal;
}

extension XErrorModule on ErrorModule {
  bool _shouldLog(
    List<bool> Function(Object e)? ignoreWhen,
    Object e,
  ) =>
      !(ignoreWhen?.call(e) ?? const []).any((r) => r == true);

  T? _handleError<T>(
    T? replace,
    List<bool> Function(Object e)? ignoreWhen,
    Object e,
    StackTrace s,
  ) {
    if (replace != null) return replace;
    if (_shouldLog(ignoreWhen, e)) l.e(e, s);
  }

  T? runNullable<T>(
    T? Function() f, {
    T? Function(Object e)? handleWhen,
    List<bool> Function(Object e)? ignoreWhen,
  }) {
    try {
      return f();
    } on Object catch (e, s) {
      return _handleError(handleWhen?.call(e), ignoreWhen, e, s);
    }
  }

  Future<T?> runAsyncNullable<T>(
    FutureOr<T?> Function() f, {
    FutureOr<T>? Function(Object e)? handleWhen,
    List<bool> Function(Object? e)? ignoreWhen,
  }) async {
    try {
      final result = await f();
      return result;
    } on Object catch (e, s) {
      return _handleError(await handleWhen?.call(e), ignoreWhen, e, s);
    }
  }

  Future<bool> runAsyncBool(
    Future<void> Function() f, {
    FutureOr<bool>? Function(Object e)? handleWhen,
    List<bool> Function(Object? e)? ignoreWhen,
  }) =>
      runAsyncNullable(
        () async {
          await f();
          return true;
        },
        ignoreWhen: ignoreWhen,
        handleWhen: handleWhen,
      ).then((r) => r ?? false);

  T runConcealing<T>(
    T Function() f,
    T Function() onError,
  ) =>
      runNullable(f, ignoreWhen: (_) => const [true]) ?? onError();
}

const errorModule = ErrorModule._();
