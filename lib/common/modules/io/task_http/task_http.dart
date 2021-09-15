import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/modules/io/task_http/task_http_client.dart';
import 'package:http/http.dart';

mixin TaskHttp {
  static Task<T> batchWith<T>(
    Client Function() client,
    Task<T> Function(TaskHttpClient client) f,
  ) =>
      Task.of(TaskHttpClient(client())).flatMap(
        (client) => f(client).performDiscardIO(client.close()),
      );

  static Task<T> batchDefault<T>(
    Task<T> Function(TaskHttpClient client) f,
  ) =>
      batchWith(() => Client(), f);
}
