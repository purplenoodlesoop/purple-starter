import 'package:dio/dio.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IDependenciesStorage {
  Dio get dio;
  AppDatabase get database;
  SharedPreferences get sharedPreferences;

  void close();
}

class DependenciesStorage implements IDependenciesStorage {
  final String _databaseName;
  final SharedPreferences _sharedPreferences;

  DependenciesStorage({
    required String databaseName,
    required SharedPreferences sharedPreferences,
  })  : _databaseName = databaseName,
        _sharedPreferences = sharedPreferences;

  Dio? _dio;

  AppDatabase? _database;

  @override
  Dio get dio => _dio ??= Dio();

  @override
  AppDatabase get database => _database ??= AppDatabase(name: _databaseName);

  @override
  SharedPreferences get sharedPreferences => _sharedPreferences;

  @override
  Future<void> close() async {
    _dio?.close();
    await _database?.close();
  }
}
