import 'package:dio/dio.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/constants.dart';

class ApiKeyInterceptor extends Interceptor {
  final AppPrefs _appPrefs;

  ApiKeyInterceptor(this._appPrefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String baseUrl = options.baseUrl;
    String? apiKey;

    switch (baseUrl) {
      case Constants.tmdbBaseUrl:
        apiKey = await _appPrefs.getCustomTmdbApiKey();
        options.queryParameters['api_key'] = apiKey.isNotEmpty
            ? apiKey
            : ApiKeys.defaultTmdb;
        break;
      case Constants.rawgBaseUrl:
        apiKey = await _appPrefs.getCustomRawgApiKey();
        options.queryParameters['key'] = apiKey.isNotEmpty
            ? apiKey
            : ApiKeys.defaultRawg;
        break;
      case Constants.googleBooksBaseUrl:
        apiKey = await _appPrefs.getCustomBooksApiKey();
        options.queryParameters['key'] = apiKey.isNotEmpty
            ? apiKey
            : ApiKeys.defaultGoogleBooks;
        break;
    }

    handler.next(options);
  }
}
