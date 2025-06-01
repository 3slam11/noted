import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String empty = '';
  static const String baseUrl = '';
  static const int zero = 0;
  static const int timeOut = 60000; // 1 minute
  static const String language = 'en';

  static const String googleBooksBaseUrl =
      'https://www.googleapis.com/books/v1';
  static const String rawgBaseUrl = 'https://api.rawg.io/api';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';

  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';
}

class ApiKeys {
  static final String defaultGoogleBooks =
      dotenv.env['DEFAULT_GOOGLE_BOOKS_API_KEY']!;
  static final String defaultRawg = dotenv.env['DEFAULT_RAWG_API_KEY']!;
  static final String defaultTmdb = dotenv.env['DEFAULT_TMDB_API_KEY']!;
}
