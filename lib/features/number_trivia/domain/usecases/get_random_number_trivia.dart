import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  Future<Either<Failure, NumberTriviaEntity>> call(NoParams noParams) {
    return repository.getRandomNumberTrivia();
  }
}
