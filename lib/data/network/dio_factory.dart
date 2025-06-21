import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/data/network/api_key_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final AppPrefs _appPrefs;
  DioFactory(this._appPrefs);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    dio.options = BaseOptions(
      receiveTimeout: const Duration(milliseconds: Constants.timeOut),
      connectTimeout: const Duration(milliseconds: Constants.timeOut),
    );

    dio.interceptors.add(ApiKeyInterceptor(_appPrefs));

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}
