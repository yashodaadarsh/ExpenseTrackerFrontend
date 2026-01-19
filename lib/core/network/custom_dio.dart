import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/print_value.dart';

Dio getDio() {
  Dio dio = Dio();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        printValue(tag: "API URL", value: options.uri.toString());
        printValue(tag: "HEADER", value: options.headers);
        printValue(tag: "QueryParameters" , value: options.queryParameters );
        printValue(
          tag: "REQUEST BODY",
          value: jsonEncode(options.data),
        );
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        printValue(tag: "API RESPONSE", value: response.data);
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        printValue(
          tag: "STATUS CODE",
          value: e.response?.statusCode.toString() ?? "",
        );
        printValue(
          tag: "ERROR DATA",
          value: e.response?.data ?? "",
        );
        return handler.next(e);
      },
    ),
  );

  return dio;
}
