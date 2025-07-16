import 'package:noted/data/network/app_api.dart';
import 'package:noted/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<MainResponse> getHome();
  Future<MoviesSearchResponse> searchMovies(String query);
  Future<TvSearchResponse> searchTVSeries(String query);
  Future<BooksSearchResponse> searchBooks(String query);
  Future<GamesSearchResponse> searchGames(String query, {int? publishers});
  Future<MovieDetailsResponse> getMovieDetails(int id);
  Future<TvDetailsResponse> getTVSeriesDetails(int id);
  Future<BookDetailsResponse> getBookDetails(String id);
  Future<GameDetailsResponse> getGameDetails(int id);
  Future<MoviesSearchResponse> getMovieRecommendations(int id);
  Future<TvSearchResponse> getTVSeriesRecommendations(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  final BooksApiClient _booksApiClient;
  final GamesApiClient _gamesApiClient;
  final TmdbApiClient _tmdbApiClient;
  RemoteDataSourceImpl(
    this._appServiceClient,
    this._booksApiClient,
    this._gamesApiClient,
    this._tmdbApiClient,
  );
  @override
  Future<MainResponse> getHome() async {
    return _appServiceClient.getHome();
  }

  @override
  Future<MoviesSearchResponse> searchMovies(String query) async {
    return _tmdbApiClient.searchMovies(query);
  }

  @override
  Future<MovieDetailsResponse> getMovieDetails(int id) async {
    return _tmdbApiClient.getMovieDetails(id);
  }

  @override
  Future<TvSearchResponse> searchTVSeries(String query) async {
    return _tmdbApiClient.searchTVSeries(query);
  }

  @override
  Future<TvDetailsResponse> getTVSeriesDetails(int id) async {
    return _tmdbApiClient.getTVSeriesDetails(id);
  }

  @override
  Future<BooksSearchResponse> searchBooks(String query) async {
    return _booksApiClient.searchBooks(query);
  }

  @override
  Future<BookDetailsResponse> getBookDetails(String id) async {
    return _booksApiClient.getBookDetails(id);
  }

  @override
  Future<GamesSearchResponse> searchGames(
    String query, {
    int? publishers,
  }) async {
    return _gamesApiClient.searchGames(query, publishers: publishers);
  }

  @override
  Future<GameDetailsResponse> getGameDetails(int id) async {
    return _gamesApiClient.getGameDetails(id);
  }

  @override
  Future<MoviesSearchResponse> getMovieRecommendations(int id) async {
    return _tmdbApiClient.getMovieRecommendations(id);
  }

  @override
  Future<TvSearchResponse> getTVSeriesRecommendations(int id) async {
    return _tmdbApiClient.getTVSeriesRecommendations(id);
  }
}
