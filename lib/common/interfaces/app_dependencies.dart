import 'package:dio/dio.dart';

abstract class IAppDependencies {
  Dio get dioClient;
}
