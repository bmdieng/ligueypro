import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({String? baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? 'https://api.ligueypro.sn/v1',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
        ));

  final Dio dio;
}
