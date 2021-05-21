import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaEntity> _RandomOrConcreteChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDatasource localDatasource;
  final NumberTriviaRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.localDatasource,
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int numberTrivia) async {
    return _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(numberTrivia));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
    _RandomOrConcreteChooser getRandomOrConcreteTrivia,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        NumberTriviaModel numberTriviaModel = await getRandomOrConcreteTrivia();
        await localDatasource.cachNumberTrivia(numberTriviaModel);
        return Right(numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        NumberTriviaModel numberTriviaModel =
            await localDatasource.getLastNumberTrivia();
        return Right(numberTriviaModel);
      } on CachException {
        return Left(CachFailure());
      }
    }
  }
}
