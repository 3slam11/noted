import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';

abstract class Repository {
  Future<Either<Failure, MainObject>> getHome();

  Future<Either<Failure, SearchResults>> searchItems(
    String query,
    Category category,
  );
  Future<Either<Failure, Details>> getDetails(String id, Category category);

  Future<Either<Failure, void>> addTodo(ItemResponse todo);
  Future<Either<Failure, void>> deleteTodo(Item item);
  Future<Either<Failure, void>> moveToFinished(Item item);

  Future<Either<Failure, void>> deleteFinished(Item item);
  Future<Either<Failure, void>> moveToTodo(Item item);
  Future<Either<Failure, void>> moveToHistory(Item item);

  Future<Either<Failure, List<Item>>> getHistory();
  Future<Either<Failure, void>> deleteHistoryItem(Item item);
}
