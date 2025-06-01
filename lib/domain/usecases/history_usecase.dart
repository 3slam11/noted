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
}
