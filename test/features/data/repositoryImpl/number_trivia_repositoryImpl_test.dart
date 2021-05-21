import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositoriesImpl/number_trivia_repositoryImpl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

class MockRemoteDatasource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDatasource mockRemoteDataSource;
  MockLocalDatasource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDatasource();
    mockLocalDataSource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDatasource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runOnlineTests(Function() body) {
    group('The device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runOfflineTests(Function() body) {
    group('The device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  ///tests for getConcreteNumberTrivia
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test text');
    final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    runOnlineTests(() {
      test('Should check if the device is connected', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNetworkInfo.isConnected);
      });

      test('Should return number trivia from remote data source', () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTriviaEntity)));
      });

      test(
          'Should cach data locally when the call to the remote datasource is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cachNumberTrivia(tNumberTriviaModel));
        expect(result, Right(tNumberTriviaEntity));
      });

      test(
          'Should return Server failure when the call to the remote datasource is unsuccessfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runOfflineTests(() {
      test('Should return the last stored number trivia from local datasource',
          () async {
        //aarange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaEntity));
      });

      test('Should return a CashException if there s no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CachException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result, Left(CachFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
    final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    runOnlineTests(() {
      test('Should check if the device is connected', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getRandomNumberTrivia();
        //assert
        verify(mockNetworkInfo.isConnected);
      });

      test('Should return number trivia from remote data source', () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTriviaEntity)));
      });

      test(
          'Should cach data locally when the call to the remote datasource is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cachNumberTrivia(tNumberTriviaModel));
        expect(result, Right(tNumberTriviaEntity));
      });

      test(
          'Should return Server failure when the call to the remote datasource is unsuccessfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runOfflineTests(() {
      test('Should return the last stored number trivia from local datasource',
          () async {
        //aarange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaEntity));
      });

      test('Should return a CashException if there s no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CachException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result, Left(CachFailure()));
      });
    });
  });
}
