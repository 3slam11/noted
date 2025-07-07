import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';

class HistoryUsecase implements BaseUsecase<void, List<Item>> {
  final Repository repository;
  HistoryUsecase(this.repository);
  @override
  Future<Either<Failure, List<Item>>> execute(void input) {
    return repository.getHistory();
  }

  Future<Either<Failure, void>> updateItem(Item item) {
    return repository.updateItem(item);
  }

  Future<Either<Failure, void>> deleteHistoryItem(Item item) {
    return repository.deleteHistoryItem(item);
  }

  Future<Either<Failure, void>> moveToTodo(Item item) {
    return repository.moveToTodo(item);
  }

  Future<Either<Failure, void>> moveToFinished(Item item) {
    return repository.moveToFinished(item);
  }
}
