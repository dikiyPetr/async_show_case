import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_key.dart';
import 'auth_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://api.nasa.gov/",
        queryParameters: {
          // ключ можно получить тут https://api.nasa.gov
          'api_key': apiKey,
        },
      ),
    );
    // callback, который конвертирует ответ из строки в json
    (dio.transformer as DefaultTransformer).jsonDecodeCallback =
        (string) => compute(_convertToJson, string);
    // перехватчики всех запросов. В них можно поймать запрос,
    // изменить его параметры, а потом отдать на исполнение
    dio.interceptors.add(AuthInterceptor());
    return dio;
  }

  static dynamic _convertToJson(String string) => json.decode(string);
}
