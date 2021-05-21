import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/failures.dart';

class InputConverter {
  Either<Failure, int> getUnsignedInteger(String numberString) {
    try {
      final int number = int.parse(numberString);
      if (number >= 0)
        return Right(number);
      else
        throw FormatException();
    } on FormatException {
      return Left(InputFailure());
    }
  }
}

class InputFailure extends Failure {}
