import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/data/network/app_api.dart';
import 'package:noted/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<MainResponse> getHome();

  Future<MoviesSearchResponse> searchMovies(String query);
  Future<TvSearchResponse> searchTVSeries(String query);
  Future<BooksSearchResponse> searchBooks(String query);
  Future<GamesSearchResponse> searchGames(String query);

  Future<MovieDetailsResponse> getMovieDetails(int id);
  Future<TvDetailsResponse> getTVSeriesDetails(int id);
  Future<BookDetailsResponse> getBookDetails(String id);
  Future<GameDetailsResponse> getGameDetails(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  final BooksApiClient _booksApiClient;
  final GamesApiClient _gamesApiClient;
  final TmdbApiClient _tmdbApiClient;
  final AppPrefs _appPrefs;

  RemoteDataSourceImpl(
    this._appServiceClient,
    this._booksApiClient,
    this._gamesApiClient,
    this._tmdbApiClient,
    this._appPrefs,
  );

  @override
  Future<MainResponse> getHome() async {
    return await _appServiceClient.getHome();
  }

  @override
  Future<MoviesSearchResponse> searchMovies(String query) async {
    String apiKey = await _appPrefs.getCustomTmdbApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultTmdb;
    }
    return await _tmdbApiClient.searchMovies(query, apiKey);
  }

  @override
  Future<MovieDetailsResponse> getMovieDetails(int id) async {
    String apiKey = await _appPrefs.getCustomTmdbApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultTmdb;
    }
    return await _tmdbApiClient.getMovieDetails(id, apiKey);
  }

  @override
  Future<TvSearchResponse> searchTVSeries(String query) async {
    String apiKey = await _appPrefs.getCustomTmdbApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultTmdb;
    }
    return await _tmdbApiClient.searchTVSeries(query, apiKey);
  }

  @override
  Future<TvDetailsResponse> getTVSeriesDetails(int id) async {
    String apiKey = await _appPrefs.getCustomTmdbApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultTmdb;
    }
    return await _tmdbApiClient.getTVSeriesDetails(id, apiKey);
  }

  @override
  Future<BooksSearchResponse> searchBooks(String query) async {
    String apiKey = await _appPrefs.getCustomBooksApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultGoogleBooks;
    }
    return await _booksApiClient.searchBooks(query, apiKey);
  }

  @override
  Future<BookDetailsResponse> getBookDetails(String id) async {
    String apiKey = await _appPrefs.getCustomBooksApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultGoogleBooks;
    }
    return await _booksApiClient.getBookDetails(id, apiKey);
  }

  @override
  Future<GamesSearchResponse> searchGames(String query) async {
    String apiKey = await _appPrefs.getCustomRawgApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultRawg;
    }
    return await _gamesApiClient.searchGames(query, apiKey);
  }

  @override
  Future<GameDetailsResponse> getGameDetails(int id) async {
    String apiKey = await _appPrefs.getCustomRawgApiKey();
    if (apiKey.isEmpty) {
      apiKey = ApiKeys.defaultRawg;
    }
    return await _gamesApiClient.getGameDetails(id, apiKey);
  }
}
