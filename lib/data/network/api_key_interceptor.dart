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

    if (baseUrl == Constants.tmdbBaseUrl) {
      String apiKey = await _appPrefs.getCustomTmdbApiKey();
      if (apiKey.isEmpty) apiKey = ApiKeys.defaultTmdb;
      options.queryParameters['api_key'] = apiKey;
    } else if (baseUrl == Constants.rawgBaseUrl) {
      String apiKey = await _appPrefs.getCustomRawgApiKey();
      if (apiKey.isEmpty) apiKey = ApiKeys.defaultRawg;
      options.queryParameters['key'] = apiKey;
    } else if (baseUrl == Constants.googleBooksBaseUrl) {
      String apiKey = await _appPrefs.getCustomBooksApiKey();
      if (apiKey.isEmpty) apiKey = ApiKeys.defaultGoogleBooks;
      options.queryParameters['key'] = apiKey;
    }

    super.onRequest(options, handler);
  }
}
