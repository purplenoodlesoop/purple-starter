import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:functional_starter/common/modules/io/task_http/task_http_client.dart';
import 'package:http/http.dart';

mixin TaskHttp {
  static Task<T> batchWith<T>(
    Client Function() client,
    Task<T> Function(TaskHttpClient client) f,
  ) =>
      IO(() => TaskHttpClient(client())).flatMapTask(
        (client) => f(client).performDiscardIO(client.close()),
      );

  static Task<T> batch<T>(
    Task<T> Function(TaskHttpClient client) f,
  ) =>
      batchWith(() => Client(), f);
}
