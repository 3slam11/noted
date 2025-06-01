import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';

class DetailsUsecase implements BaseUsecase<DetailsInput, Details> {
  final Repository repository;

  DetailsUsecase(this.repository);

  @override
  Future<Either<Failure, Details>> execute(DetailsInput input) {
    return repository.getDetails(input.id, input.category);
  }
}

class DetailsInput {
  String id;
  Category category;

  DetailsInput(this.id, this.category);
}
