import 'package:dio/dio.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';

class DioLoggerInterceptor extends Interceptor with IdentityLoggingMixin {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logData((b) {
      b
        ..write('Performing ')
        ..write(options.method)
        ..write(' ')
        ..write(options.responseType.name)
        ..write(' request to ')
        ..write(options.path);
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    logData(
      (b) => b
        ..write('Received ')
        ..write(response.statusMessage ?? response.statusCode)
        ..write(' from ')
        ..write(options.method)
        ..write(' to ')
        ..write(options.path),
    );
    super.onResponse(response, handler);
  }
}
