import 'package:dio/dio.dart';
import 'package:mark/mark.dart';
import 'package:purple_starter/src/core/di/shared_parent.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';

abstract class DioLoggerInterceptorDependencies implements LoggerDependency {}

class DioLoggerInterceptor extends Interceptor with IdentityLoggingMixin {
  final DioLoggerInterceptorDependencies _dependencies;

  DioLoggerInterceptor(this._dependencies);

  @override
  Logger get logger => _dependencies.logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log((b) {
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
  void onResponse(
    // Dio forces to use the dynamic type here.
    // ignore: avoid-dynamic
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    log(
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
