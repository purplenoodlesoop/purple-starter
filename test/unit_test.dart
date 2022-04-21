// ignore_for_file: unnecessary_lambdas, prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:purple_starter/runner_stub.dart' as runner_stub;
import 'package:purple_starter/src/core/error/parsing_exception.dart';
import 'package:purple_starter/src/core/error/unknown_host_platform_error.dart';
import 'package:purple_starter/src/core/router/app_router.dart';

import 'package:test/test.dart';

void main() {
  group('Smoke unit test', () {
    test('placeholder', () {
      expectLater(runner_stub.run, throwsA(isA<UnknownHostPlatformError>()));
      expect(() => PlaceholderPage(), returnsNormally);
      expect(PlaceholderPage(), isA<Widget>());
      expect(PlaceholderPage().key, equals(PlaceholderPage().key));
      expect(
        PlaceholderPage(
          key: ValueKey<String>('key'),
        ).key,
        isNot(equals(PlaceholderPage().key)),
      );
      expect(
        PlaceholderPage().runtimeType,
        same(PlaceholderPage().runtimeType),
      );
      expect(ParsingException<int, String>(0).toString(), isA<String>());
      expect(() => ParsingException<int, String>(0), returnsNormally);
    });
  });
}
