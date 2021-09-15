import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:provider_msg/provider_msg.dart';

extension ContextExtensions on BuildContext {
  IO<Unit> sendIO<Model>(Msg<Model> msg) => IO(() => send(msg)).asUnit();
}
