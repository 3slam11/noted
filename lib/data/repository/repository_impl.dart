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

  // Home data methods
  @override
  Future<Either<Failure, MainObject>> getHome() async {
    try {
      final (todos, finished) = await Future.wait([
        _localDataSource.getTodo(),
        _localDataSource.getFinished(),
      ]).then((results) => (results[0], results[1]));

      final taskData = TaskData(
        todos.map((response) => response.toDomain()).toList(),
        finished.map((response) => response.toDomain()).toList(),
      );

      return Right(MainObject(taskData));
    } catch (error) {
      return Left(_createCacheFailure("Failed to load list data", error));
    }
  }

  // Search methods
  @override
  Future<Either<Failure, SearchResults>> searchItems(
    String query,
    Category category,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final items = await _searchByCategory(query, category);
      return Right(SearchResults(items: items));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  Future<List<SearchItem>> _searchByCategory(
    String query,
    Category category,
  ) async {
    switch (category) {
      case Category.movies:
        return _searchMovies(query);
      case Category.series:
        return _searchTVSeries(query);
      case Category.books:
        return _searchBooks(query);
      case Category.games:
        return _searchGames(query);
      case Category.all:
        throw UnimplementedError('Search all categories not supported');
    }
  }

  Future<List<SearchItem>> _searchMovies(String query) async {
    final response = await _remoteDataSource.searchMovies(query);
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
  }

  Future<List<SearchItem>> _searchTVSeries(String query) async {
    final response = await _remoteDataSource.searchTVSeries(query);
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
  }

  Future<List<SearchItem>> _searchBooks(String query) async {
    final response = await _remoteDataSource.searchBooks(query);
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
  }

  Future<List<SearchItem>> _searchGames(String query) async {
    final response = await _remoteDataSource.searchGames(query);
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
  }

  // Details methods
  @override
  Future<Either<Failure, Details>> getDetails(
    String id,
    Category category,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final details = await _getDetailsByCategory(id, category);
      return Right(details);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  Future<Details> _getDetailsByCategory(String id, Category category) async {
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
        throw UnimplementedError(
          'Get details for all categories not supported',
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

  // Item management methods
  @override
  Future<Either<Failure, void>> addTodo(ItemResponse todoItem) async {
    return _performLocalOperation(
      () => _localDataSource.addTodo(todoItem),
      "Failed to save item locally",
    );
  }

  @override
  Future<Either<Failure, void>> moveToFinished(Item item) async {
    return _performItemValidationAndOperation(item, () async {
      await _localDataSource.removeTodo(item.id!, item.category!);
      await _localDataSource.addFinished(item.toResponse());
    }, "Failed to move item to finished");
  }

  @override
  Future<Either<Failure, void>> moveToTodo(Item item) async {
    return _performItemValidationAndOperation(item, () async {
      await _localDataSource.removeFinished(item.id!, item.category!);
      await _localDataSource.addTodo(item.toResponse());
    }, "Failed to move item to todo");
  }

  @override
  Future<Either<Failure, void>> moveToHistory(Item item) async {
    return _performItemValidationAndOperation(item, () async {
      await Future.wait([
        _localDataSource.removeFinished(item.id!, item.category!),
        _localDataSource.removeTodo(item.id!, item.category!),
      ]);
      await _localDataSource.addHistory(item.toResponse());
    }, "Failed to move item to history");
  }

  @override
  Future<Either<Failure, void>> deleteTodo(Item item) async {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.removeTodo(item.id!, item.category!),
      "Failed to delete todo item",
    );
  }

  @override
  Future<Either<Failure, void>> deleteFinished(Item item) async {
    return _performItemValidationAndOperation(
      item,
      () => _localDataSource.removeFinished(item.id!, item.category!),
      "Failed to delete finished item",
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
      return Left(_createCacheFailure("Failed to load history items", error));
    }
  }

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
          "Item ID or Category cannot be null",
        ),
      );
    }

    return _performLocalOperation(operation, errorMessage);
  }

  Failure _createCacheFailure(String message, Object error) {
    return Failure(
      DataSource.CACHE_ERROR.getFailure().code,
      "$message: ${error.toString()}",
    );
  }
}
