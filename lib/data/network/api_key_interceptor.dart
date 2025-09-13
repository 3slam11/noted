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

    // A helper function to get the key and simplify the switch statement.
    Future<String> getApiKey(
      Future<String> customKeyFuture,
      String defaultKey,
    ) async {
      final customKey = await customKeyFuture;
      // IMPROVEMENT: Simplified logic. If customKey is empty, use defaultKey.
      return customKey.isNotEmpty ? customKey : defaultKey;
    }

    switch (baseUrl) {
      case Constants.tmdbBaseUrl:
        options.queryParameters['api_key'] = await getApiKey(
          _appPrefs.getCustomTmdbApiKey(),
          ApiKeys.defaultTmdb,
        );
        break;
      case Constants.rawgBaseUrl:
        options.queryParameters['key'] = await getApiKey(
          _appPrefs.getCustomRawgApiKey(),
          ApiKeys.defaultRawg,
        );
        break;
      case Constants.googleBooksBaseUrl:
        options.queryParameters['key'] = await getApiKey(
          _appPrefs.getCustomBooksApiKey(),
          ApiKeys.defaultGoogleBooks,
        );
        break;
    }

    handler.next(options);
  }
}
