import 'package:noted/data/network/app_api.dart';
import 'package:noted/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<MainResponse> getHome();
  Future<MoviesSearchResponse> searchMovies(String query, {int page = 1});
  Future<TvSearchResponse> searchTVSeries(String query, {int page = 1});
  Future<BooksSearchResponse> searchBooks(String query, {int startIndex = 0});
  Future<GamesSearchResponse> searchGames(
    String query, {
    int page = 1,
    int? publishers,
  });
  Future<JikanSearchResponse> searchAnime(String query, {int page = 1});
  Future<JikanSearchResponse> searchManga(String query, {int page = 1});

  Future<MovieDetailsResponse> getMovieDetails(int id);
  Future<TvDetailsResponse> getTVSeriesDetails(int id);
  Future<BookDetailsResponse> getBookDetails(String id);
  Future<GameDetailsResponse> getGameDetails(int id);
  Future<JikanDetailsResponse> getAnimeDetails(int id);
  Future<JikanDetailsResponse> getMangaDetails(int id);

  Future<MoviesSearchResponse> getMovieRecommendations(int id);
  Future<TvSearchResponse> getTVSeriesRecommendations(int id);
  Future<JikanRecommendationsResponse> getAnimeRecommendations(int id);
  Future<JikanRecommendationsResponse> getMangaRecommendations(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  final BooksApiClient _booksApiClient;
  final GamesApiClient _gamesApiClient;
  final TmdbApiClient _tmdbApiClient;
  final JikanApiClient _jikanApiClient;

  RemoteDataSourceImpl(
    this._appServiceClient,
    this._booksApiClient,
    this._gamesApiClient,
    this._tmdbApiClient,
    this._jikanApiClient,
  );

  @override
  Future<MainResponse> getHome() async {
    return _appServiceClient.getHome();
  }

  @override
  Future<MoviesSearchResponse> searchMovies(
    String query, {
    int page = 1,
  }) async {
    return _tmdbApiClient.searchMovies(query, page: page);
  }

  @override
  Future<MovieDetailsResponse> getMovieDetails(int id) async {
    return _tmdbApiClient.getMovieDetails(id);
  }

  @override
  Future<TvSearchResponse> searchTVSeries(String query, {int page = 1}) async {
    return _tmdbApiClient.searchTVSeries(query, page: page);
  }

  @override
  Future<TvDetailsResponse> getTVSeriesDetails(int id) async {
    return _tmdbApiClient.getTVSeriesDetails(id);
  }

  @override
  Future<BooksSearchResponse> searchBooks(
    String query, {
    int startIndex = 0,
  }) async {
    return _booksApiClient.searchBooks(query, startIndex: startIndex);
  }

  @override
  Future<BookDetailsResponse> getBookDetails(String id) async {
    return _booksApiClient.getBookDetails(id);
  }

  @override
  Future<GamesSearchResponse> searchGames(
    String query, {
    int page = 1,
    int? publishers,
  }) async {
    return _gamesApiClient.searchGames(
      query,
      page: page,
      publishers: publishers,
    );
  }

  @override
  Future<GameDetailsResponse> getGameDetails(int id) async {
    return _gamesApiClient.getGameDetails(id);
  }

  @override
  Future<JikanSearchResponse> searchAnime(String query, {int page = 1}) async {
    return _jikanApiClient.searchAnime(query, page: page);
  }

  @override
  Future<JikanDetailsResponse> getAnimeDetails(int id) async {
    return _jikanApiClient.getAnimeDetails(id);
  }

  @override
  Future<JikanSearchResponse> searchManga(String query, {int page = 1}) async {
    return _jikanApiClient.searchManga(query, page: page);
  }

  @override
  Future<JikanDetailsResponse> getMangaDetails(int id) async {
    return _jikanApiClient.getMangaDetails(id);
  }

  @override
  Future<MoviesSearchResponse> getMovieRecommendations(int id) async {
    return _tmdbApiClient.getMovieRecommendations(id);
  }

  @override
  Future<TvSearchResponse> getTVSeriesRecommendations(int id) async {
    return _tmdbApiClient.getTVSeriesRecommendations(id);
  }

  @override
  Future<JikanRecommendationsResponse> getAnimeRecommendations(int id) async {
    return _jikanApiClient.getAnimeRecommendations(id);
  }

  @override
  Future<JikanRecommendationsResponse> getMangaRecommendations(int id) async {
    return _jikanApiClient.getMangaRecommendations(id);
  }
}
