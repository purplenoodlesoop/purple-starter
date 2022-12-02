import 'package:dio/dio.dart';
import 'package:purple_starter/src/core/database/drift/app_database.dart';
import 'package:purple_starter/src/feature/app/api/dio_logger_interceptor.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract class IDependenciesStorage {
  Dio get dio;
  AppDatabase get database;
  PreferencesDriver get preferencesDriver;

  void close();
}

class DependenciesStorage implements IDependenciesStorage {
  final String _databaseName;
  final PreferencesDriver _preferencesDriver;

  DependenciesStorage({
    required String databaseName,
    required PreferencesDriver preferencesDriver,
  })  : _databaseName = databaseName,
        _preferencesDriver = preferencesDriver;

  Dio? _dio;

  AppDatabase? _database;

  @override
  Dio get dio => _dio ??= Dio()
    ..interceptors.addAll([
      DioLoggerInterceptor(),
    ]);

  @override
  AppDatabase get database => _database ??= AppDatabase(name: _databaseName);

  @override
  PreferencesDriver get preferencesDriver => _preferencesDriver;

  @override
  Future<void> close() async {
    _dio?.close();
    await _database?.close();
  }
}
