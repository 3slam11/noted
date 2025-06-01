import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';

class MainUsecase implements BaseUsecase<void, MainObject> {
  final Repository repository;
  MainUsecase(this.repository);
  @override
  Future<Either<Failure, MainObject>> execute(void input) {
    return repository.getHome();
  }

  Future<Either<Failure, void>> addTodo(ItemResponse todo) {
    return repository.addTodo(todo);
  }

  Future<Either<Failure, void>> moveToFinished(Item item) {
    return repository.moveToFinished(item);
  }

  Future<Either<Failure, void>> deleteTodo(Item item) {
    return repository.deleteTodo(item);
  }

  Future<Either<Failure, void>> moveToTodo(Item item) {
    return repository.moveToTodo(item);
  }

  Future<Either<Failure, void>> deleteFinished(Item item) {
    return repository.deleteFinished(item);
  }

  Future<Either<Failure, void>> moveToHistory(Item item) {
    return repository.moveToHistory(item);
  }
}
