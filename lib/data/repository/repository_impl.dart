import 'package:dartz/dartz.dart';
import 'package:noted/data/data_source/local_data_source.dart';
import 'package:noted/data/data_source/remote_data_source.dart';
import 'package:noted/data/mapper/mapper.dart';
import 'package:noted/data/network/error_handler.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/data/network/network_info.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, T>> _executeNetworkCall<T>(
    Future<T> Function() call,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      final result = await call();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  // Home data methods
  @override
  Future<Either<Failure, MainObject>> getHome() async {
    try {
      final results = await Future.wait([
        _localDataSource.getTodo(),
        _localDataSource.getFinished(),
      ]);

      final todos = results[0].map((response) => response.toDomain()).toList();
      final finished = results[1]
          .map((response) => response.toDomain())
          .toList();

      return Right(MainObject(TaskData(todos, finished)));
    } catch (error) {
      return Left(_createCacheFailure("Failed to load list data", error));
    }
  }

  // Search methods
  @override
  Future<Either<Failure, SearchResults>> searchItems(
    String query,
    Category category,
  ) {
    return _executeNetworkCall(() async {
      final response = await _searchByCategory(query, category);
      return SearchResults(items: response);
    });
  }

  Future<List<SearchItem>> _searchByCategory(
    String query,
    Category category,
  ) async {
    final response = switch (category) {
      Category.movies => await _remoteDataSource.searchMovies(query),
      Category.series => await _remoteDataSource.searchTVSeries(query),
      Category.books => await _remoteDataSource.searchBooks(query),
      Category.games => await _remoteDataSource.searchGames(query),
      Category.all => throw UnsupportedError(
        'Search for "All" category is not implemented.',
      ),
    };

    return switch (response) {
      MoviesSearchResponse r =>
        r.results
                ?.map(
                  (movie) => SearchItem(
                    id: movie.id.toString(),
                    title: movie.title ?? '',
                    imageUrl: movie.posterUrl,
                    releaseDate: movie.releaseDate,
                    category: Category.movies,
                  ),
                )
                .toList() ??
            [],
      TvSearchResponse r =>
        r.results
                ?.map(
                  (tv) => SearchItem(
                    id: tv.id.toString(),
                    title: tv.title ?? '',
                    imageUrl: tv.posterUrl,
                    releaseDate: tv.releaseDate,
                    category: Category.series,
                  ),
                )
                .toList() ??
            [],
      BooksSearchResponse r =>
        r.results
                ?.map(
                  (book) => SearchItem(
                    id: book.id ?? '',
                    title: book.title ?? '',
                    imageUrl: book.posterUrl,
                    releaseDate: book.releaseDate,
                    category: Category.books,
                  ),
                )
                .toList() ??
            [],
      GamesSearchResponse r =>
        r.results
                ?.map(
                  (game) => SearchItem(
                    id: game.id.toString(),
                    title: game.title ?? '',
                    imageUrl: game.posterUrl,
                    releaseDate: game.releaseDate,
                    category: Category.games,
                  ),
                )
                .toList() ??
            [],
      _ => [],
    };
  }

  // Details methods
  @override
  Future<Either<Failure, Details>> getDetails(String id, Category category) {
    return _executeNetworkCall(() => _getDetailsByCategory(id, category));
  }

  Future<Details> _getDetailsByCategory(String id, Category category) {
    switch (category) {
      case Category.movies:
        return _getMovieDetails(id);
      case Category.series:
        return _getTVSeriesDetails(id);
      case Category.books:
        return _getBookDetails(id);
      case Category.games:
        return _getGameDetails(id);
      case Category.all:
        throw UnsupportedError(
          'Get details for "All" category is not supported',
        );
    }
  }

  Future<Details> _getMovieDetails(String id) async {
    final response = await _remoteDataSource.getMovieDetails(int.parse(id));
    return Details(
      id: id,
      title: response.title ?? '',
      description: response.description,
      releaseDate: response.releaseDate,
      rating: response.rating,
      publisher: response.companyName,
      imageUrls: response.imageGalleryUrls,
      category: Category.movies,
    );
  }

  Future<Details> _getTVSeriesDetails(String id) async {
    final response = await _remoteDataSource.getTVSeriesDetails(int.parse(id));
    return Details(
      id: id,
      title: response.title ?? '',
      description: response.description,
      releaseDate: response.releaseDate,
      rating: response.rating,
      publisher: response.companyName,
      imageUrls: response.imageGalleryUrls,
      category: Category.series,
    );
  }

  Future<Details> _getBookDetails(String id) async {
    final response = await _remoteDataSource.getBookDetails(id);
    return Details(
      id: id,
      title: response.title ?? '',
      description: response.description,
      releaseDate: response.releaseDate,
      rating: response.rating,
      publisher: response.publisher,
      imageUrls: response.imageGalleryUrls,
      category: Category.books,
    );
  }

  Future<Details> _getGameDetails(String id) async {
    final response = await _remoteDataSource.getGameDetails(int.parse(id));
    return Details(
      id: id,
      title: response.title ?? '',
      description: response.description,
      releaseDate: response.releaseDate,
      rating: response.rating,
      publisher: response.publisherName,
      platforms: response.platformNames,
      imageUrls: response.imageGalleryUrls,
      category: Category.games,
    );
  }

  @override
  Future<Either<Failure, List<SearchItem>>> getRecommendations(
    String id,
    Category category,
  ) {
    return _executeNetworkCall(() async {
      final response = await _getRecommendationsByCategory(id, category);
      return response.where((item) => item.id != id).toList();
    });
  }

  Future<List<SearchItem>> _getRecommendationsByCategory(
    String id,
    Category category,
  ) async {
    switch (category) {
      case Category.movies:
        final response = await _remoteDataSource.getMovieRecommendations(
          int.parse(id),
        );
        return response.results
                ?.map(
                  (movie) => SearchItem(
                    id: movie.id.toString(),
                    title: movie.title ?? '',
                    imageUrl: movie.posterUrl,
                    releaseDate: movie.releaseDate,
                    category: Category.movies,
                  ),
                )
                .toList() ??
            [];
      case Category.series:
        final response = await _remoteDataSource.getTVSeriesRecommendations(
          int.parse(id),
        );
        return response.results
                ?.map(
                  (tv) => SearchItem(
                    id: tv.id.toString(),
                    title: tv.title ?? '',
                    imageUrl: tv.posterUrl,
                    releaseDate: tv.releaseDate,
                    category: Category.series,
                  ),
                )
                .toList() ??
            [];
      case Category.games:
        final detailsResponse = await _remoteDataSource.getGameDetails(
          int.parse(id),
        );
        final publisherId = detailsResponse.publishers?.first.id;
        if (publisherId == null) {
          return [];
        }
        final response = await _remoteDataSource.searchGames(
          '',
          publishers: publisherId,
        );
        return response.results
                ?.map(
                  (game) => SearchItem(
                    id: game.id.toString(),
                    title: game.title ?? '',
                    imageUrl: game.posterUrl,
                    releaseDate: game.releaseDate,
                    category: Category.games,
                  ),
                )
                .toList() ??
            [];
      case Category.books:
        final detailsResponse = await _remoteDataSource.getBookDetails(id);
        final author = detailsResponse.volumeInfo?.authors?.first;
        if (author == null || author.isEmpty) {
          return [];
        }
        final response = await _remoteDataSource.searchBooks(
          'inauthor:"$author"',
        );
        return response.results
                ?.map(
                  (book) => SearchItem(
                    id: book.id ?? '',
                    title: book.title ?? '',
                    imageUrl: book.posterUrl,
                    releaseDate: book.releaseDate,
                    category: Category.books,
                  ),
                )
                .toList() ??
            [];
      case Category.all:
        return [];
    }
  }

  @override
  Future<Either<Failure, void>> addTodo(ItemResponse todoItem) {
    return _performLocalOperation(
      () => _localDataSource.addTodo(todoItem),
      'Failed to save item locally',
    );
  }

  @override
  Future<Either<Failure, void>> updateItem(Item item) {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.updateItem(item.toResponse()),
      'Failed to update item',
    );
  }

  @override
  Future<Either<Failure, void>> moveToFinished(Item item) {
    return _performItemValidationAndOperation(item, () async {
      await _localDataSource.removeTodo(item.id!, item.category!);
      await _localDataSource.removeHistory(item.id!, item.category!);
      await _localDataSource.addFinished(item.toResponse());
    }, 'Failed to move item to finished');
  }

  @override
  Future<Either<Failure, void>> moveToTodo(Item item) {
    return _performItemValidationAndOperation(item, () async {
      await _localDataSource.removeFinished(item.id!, item.category!);
      await _localDataSource.removeHistory(item.id!, item.category!);
      await _localDataSource.addTodo(item.toResponse());
    }, 'Failed to move item to todo');
  }

  @override
  Future<Either<Failure, void>> moveToHistory(Item item) {
    return _performItemValidationAndOperation(item, () async {
      await _localDataSource.removeFinished(item.id!, item.category!);
      await _localDataSource.removeTodo(item.id!, item.category!);
      await _localDataSource.addHistory(item.toResponse());
    }, 'Failed to move item to history');
  }

  @override
  Future<Either<Failure, void>> deleteTodo(Item item) {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.removeTodo(item.id!, item.category!),
      'Failed to delete todo item',
    );
  }

  @override
  Future<Either<Failure, void>> deleteFinished(Item item) {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.removeFinished(item.id!, item.category!),
      'Failed to delete finished item',
    );
  }

  @override
  Future<Either<Failure, void>> deleteHistoryItem(Item item) {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.removeHistory(item.id!, item.category!),
      'Failed to delete history item',
    );
  }

  @override
  Future<Either<Failure, List<Item>>> getHistory() async {
    try {
      final historyResponses = await _localDataSource.getHistory();
      final historyItems = historyResponses
          .map((response) => response.toDomain())
          .toList();
      return Right(historyItems);
    } catch (error) {
      return Left(_createCacheFailure('Failed to load history items', error));
    }
  }

  // Helper methods for local operations
  Future<Either<Failure, void>> _performLocalOperation(
    Future<void> Function() operation,
    String errorMessage,
  ) async {
    try {
      await operation();
      return const Right(null);
    } catch (error) {
      return Left(_createCacheFailure(errorMessage, error));
    }
  }

  Future<Either<Failure, void>> _performItemValidationAndOperation(
    Item item,
    Future<void> Function() operation,
    String errorMessage,
  ) async {
    if (item.id == null || item.category == null) {
      return Left(
        Failure(
          ApiInternalStatus.FAILURE,
          'Item ID or Category cannot be null',
        ),
      );
    }
    return _performLocalOperation(operation, errorMessage);
  }

  Failure _createCacheFailure(String message, Object error) {
    return Failure(
      DataSource.CACHE_ERROR.getFailure().code,
      '$message: ${error.toString()}',
    );
  }
}
