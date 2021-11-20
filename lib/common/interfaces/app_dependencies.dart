import 'package:http/http.dart' as http;

abstract class IAppDependencies {
  http.Client get httpClient;
}
