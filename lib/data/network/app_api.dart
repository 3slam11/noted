import 'package:dio/dio.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:retrofit/retrofit.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @GET('/home')
  Future<MainResponse> getHome();
}

// books API Client
@RestApi(baseUrl: Constants.googleBooksBaseUrl)
abstract class BooksApiClient {
  factory BooksApiClient(Dio dio, {String baseUrl}) = _BooksApiClient;

  @GET('/volumes')
  Future<BooksSearchResponse> searchBooks(@Query('q') String query);

  @GET('/volumes/{id}')
  Future<BookDetailsResponse> getBookDetails(@Path('id') String id);
}

// games API Client
@RestApi(baseUrl: Constants.rawgBaseUrl)
abstract class GamesApiClient {
  factory GamesApiClient(Dio dio, {String baseUrl}) = _GamesApiClient;

  @GET('/games')
  Future<GamesSearchResponse> searchGames(
    @Query('search') String query, {
    @Query('page') int page = 1,
    @Query('page_size') int pageSize = 20,
  });

  @GET('/games/{id}')
  Future<GameDetailsResponse> getGameDetails(@Path('id') int id);
}

// movies & TV Series API Client
@RestApi(baseUrl: Constants.tmdbBaseUrl)
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  // movies
  @GET('/search/movie')
  Future<MoviesSearchResponse> searchMovies(
    @Query('query') String query, {
    @Query('page') int page = 1,
  });

  @GET('/movie/{id}')
  Future<MovieDetailsResponse> getMovieDetails(
    @Path('id') int id, {
    @Query('append_to_response') String appendToResponse = 'images',
  });

  // TV Series
  @GET('/search/tv')
  Future<TvSearchResponse> searchTVSeries(
    @Query('query') String query, {
    @Query('page') int page = 1,
  });

  @GET('/tv/{id}')
  Future<TvDetailsResponse> getTVSeriesDetails(
    @Path('id') int id, {
    @Query('append_to_response') String appendToResponse = 'images',
  });
}
