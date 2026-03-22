import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';

class SavedUsecase implements BaseUsecase<void, List<Item>> {
  final Repository repository;
  SavedUsecase(this.repository);

  @override
  Future<Either<Failure, List<Item>>> execute(void input) {
    return repository.getSaved();
  }

  Future<Either<Failure, void>> updateItem(Item item) {
    return repository.updateItem(item);
  }

  Future<Either<Failure, void>> deleteSavedItem(Item item) {
    return repository.deleteSaved(item);
  }

  Future<Either<Failure, void>> moveToTodo(Item item) {
    return repository.moveToTodo(item);
  }

  Future<Either<Failure, void>> moveToFinished(Item item) {
    return repository.moveToFinished(item);
  }

  Future<Either<Failure, void>> moveToHistory(Item item) {
    return repository.moveToHistory(item);
  }
}
