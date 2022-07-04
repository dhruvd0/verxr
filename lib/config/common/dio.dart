import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

const String productionUrl = 'https://verxr-server.vercel.app';
const String developmentUrl = 'https://verxr-dev.vercel.app';
bool _isDev() {
  if (Firebase.apps.isEmpty) {
    return true;
  }
  if (kDebugMode) {
    return true;
  }
  return (FirebaseRemoteConfig.instance.getAll().keys.isEmpty);
}

BaseOptions defaultDioOptions() {
  var url = _isDev() ? '' : FirebaseRemoteConfig.instance.getString('url');
  return BaseOptions(
    baseUrl: _isDev()
        ? developmentUrl
        : url.isEmpty
            ? developmentUrl
            : url,
    connectTimeout: 10000,
    receiveTimeout: 3000,
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  );
}

late final dio;

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
