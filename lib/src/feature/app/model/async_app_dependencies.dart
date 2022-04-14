import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AsyncAppDependencies {
  final SharedPreferences sharedPreferences;

  const AsyncAppDependencies({
    required this.sharedPreferences,
  });

  static Future<AsyncAppDependencies> obtain() async => AsyncAppDependencies(
        sharedPreferences: await SharedPreferences.getInstance(),
      );
}
