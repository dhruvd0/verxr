import 'dart:developer';

import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'https://verxr-server.vercel.app/',
  connectTimeout: 10000,
  receiveTimeout: 3000,
  headers: {
    Headers.contentTypeHeader: Headers.jsonContentType,
  },
);
final dio = Dio(options)..interceptors.add(CustomInterceptors());

class CustomInterceptors extends Interceptor {
  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
