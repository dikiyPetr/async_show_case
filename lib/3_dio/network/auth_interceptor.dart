import 'package:dio/dio.dart';

import 'api_key.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final newQueryParameters =
        Map<String, dynamic>.from(options.queryParameters);
    newQueryParameters['api_key'] =
        apiKey; // ключ можно получить тут https://api.nasa.gov
    final newOptions = options.copyWith(queryParameters: newQueryParameters);
    super.onRequest(newOptions, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
