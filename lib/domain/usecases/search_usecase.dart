import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';

class SearchUsecase implements BaseUsecase<SearchInput, SearchResults> {
  final Repository repository;

  SearchUsecase(this.repository);

  @override
  Future<Either<Failure, SearchResults>> execute(SearchInput input) async {
    // 1. Get remote search results
    final remoteResultsEither = await repository.searchItems(
      input.query,
      input.category,
    );

    return remoteResultsEither.fold((failure) => Left(failure), (
      searchResults,
    ) async {
      if (searchResults.items == null || searchResults.items!.isEmpty) {
        return Right(searchResults);
      }

      List<Item> allLocalItems = [];

      final homeDataEither = await repository.getHome();
      homeDataEither.fold((failure) {}, (mainObject) {
        allLocalItems.addAll(mainObject.mainData!.todos);
        allLocalItems.addAll(mainObject.mainData!.finished);
      });

      final historyDataEither = await repository.getHistory();
      historyDataEither.fold((failure) {}, (historyItems) {
        allLocalItems.addAll(historyItems);
      });

      final augmentedSearchItems = searchResults.items!.map((searchItem) {
        final isAdded = allLocalItems.any(
          (localItem) =>
              localItem.id == searchItem.id &&
              localItem.category == searchItem.category,
        );
        return searchItem.copyWith(isLocallyAdded: isAdded);
      }).toList();

      return Right(SearchResults(items: augmentedSearchItems));
    });
  }

  Future<Either<Failure, void>> addToTodo(ItemResponse item) {
    return repository.addTodo(item);
  }
}

class SearchInput {
  String query;
  Category category;

  SearchInput(this.query, this.category);
}
