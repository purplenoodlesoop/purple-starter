import 'package:dio/dio.dart';
import 'package:functional_starter/common/db/app_database.dart';

abstract class IAppDependencies {
  Dio get dioClient;
  AppDatabase get database;
}
