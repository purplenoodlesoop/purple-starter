import 'package:fpdart/fpdart.dart';
import 'package:provider_msg/provider_msg.dart';

extension FpCmd on Cmd {
  static Cmd<Model> ofTaskMsg<Model>(Task<Msg<Model>> Function() msg) =>
      Cmd.ofMsg(msg().run());
  static Cmd<Model> ofIO<Model>(IO<Object?> io) => Cmd.ofEffect(io.run);
}
