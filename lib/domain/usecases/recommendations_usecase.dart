import 'package:dartz/dartz.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/repository/repository.dart';
import 'package:noted/domain/usecases/base_usecase.dart';
import 'package:noted/domain/usecases/details_usecase.dart';

class RecommendationsUsecase
    implements BaseUsecase<DetailsInput, List<SearchItem>> {
  final Repository repository;

  RecommendationsUsecase(this.repository);

  @override
  Future<Either<Failure, List<SearchItem>>> execute(DetailsInput input) {
    return repository.getRecommendations(input.id, input.category);
  }
}
