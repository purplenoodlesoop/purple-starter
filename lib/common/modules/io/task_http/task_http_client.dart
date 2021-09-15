import 'dart:convert';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:functional_starter/common/extensions/extensions.dart';
import 'package:http/http.dart';

class TaskHttpClient {
  final Client _base;

  TaskHttpClient(this._base);

  Task<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      Task(() => _base.get(url, headers: headers));

  Task<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      Task(() => _base.delete(
            url,
            headers: headers,
            body: body,
            encoding: encoding,
          ));

  Task<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      Task(() => _base.head(url, headers: headers));

  Task<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      Task(() => _base.patch(
            url,
            headers: headers,
            body: body,
            encoding: encoding,
          ));

  Task<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      Task(() => _base.post(
            url,
            headers: headers,
            body: body,
            encoding: encoding,
          ));

  Task<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      Task(() => _base.put(
            url,
            headers: headers,
            body: body,
            encoding: encoding,
          ));

  Task<String> read(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      Task(() => _base.read(url, headers: headers));

  Task<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      Task(() => _base.readBytes(url, headers: headers));

  Task<StreamedResponse> send(
    BaseRequest request,
  ) =>
      Task(() => _base.send(request));

  IO<Unit> close() => IO(_base.close).asUnit();
}
