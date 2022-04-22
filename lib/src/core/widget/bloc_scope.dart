import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pure/pure.dart';
import 'package:stream_bloc/stream_bloc.dart';

typedef ScopeData<D extends Object?> = D Function(
  BuildContext context, {
  bool listen,
});

typedef NullaryScopeMethod = void Function(BuildContext context);

typedef UnaryScopeMethod<A extends Object?> = void Function(
  BuildContext context,
  A argument,
);

@immutable
class BlocScope<E extends Object?, S extends Object?,
    B extends StreamBloc<E, S>> {
  final bool _listenByDefault;

  @literal
  const BlocScope({
    bool listenByDefault = false,
  }) : _listenByDefault = listenByDefault;

  S _state(B bloc) => bloc.state;

  B _bloc(BuildContext context) => context.read<B>();

  ScopeData<D> data<D extends Object?>(
    D Function(BuildContext context, S state) data,
  ) =>
      (BuildContext context, {bool? listen}) => (listen ?? _listenByDefault)
          ? context.select<B, D>(data.curry(context).dot(_state))
          : data(context, _bloc(context).state);

  ScopeData<D> select<D extends Object?>(D Function(S state) selector) =>
      data(selector.constant.uncurry);

  NullaryScopeMethod nullary(
    E? Function(BuildContext context) createEvent,
  ) =>
      (BuildContext context) => _bloc(context).add.nullable(
            createEvent(context),
          );

  UnaryScopeMethod<A> unary<A extends Object?>(
    E? Function(BuildContext context, A argument) createEvent,
  ) =>
      (BuildContext context, A argument) => _bloc(context).add.nullable(
            createEvent(context, argument),
          );
}
