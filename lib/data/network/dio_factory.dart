import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:noted/app/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory();

  Future<Dio> getDio() async {
    Dio dio = Dio();

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      receiveTimeout: Duration(milliseconds: Constants.timeOut),
    );

    // prints logs in debug mode
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
