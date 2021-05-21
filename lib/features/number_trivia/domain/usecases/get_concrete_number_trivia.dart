import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTrivia(
    this.numberTriviaRepository,
  );

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) {
    return numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number}) : super([number]);
}
