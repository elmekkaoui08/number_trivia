import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/presentation/util/input_converter.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcereteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInpuConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcereteNumberTrivia mockConcrete;
  MockGetRandomNumberTrivia mockRandom;
  MockInpuConverter mockConverter;

  setUp(() {
    mockConverter = MockInpuConverter();
    mockRandom = MockGetRandomNumberTrivia();
    mockConcrete = MockGetConcereteNumberTrivia();
    bloc = NumberTriviaBloc(
      concrete: mockConcrete,
      random: mockRandom,
      converter: mockConverter,
    );
  });

  test('Should check if the intialState is Empty', () async {
    //assert
    expect(bloc.initialState, equals(NumberTriviaInitial()));
  });

  group('GetConcreteNumberTriviaEvent', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockConverter.getUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
    test('Should call the InputConverter to convert the string to an integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      await untilCalled(mockConverter.getUnsignedInteger(any));
      //assert
      verify(mockConverter.getUnsignedInteger(tNumberString));
    });

    test('Should emit an [ERROR] when the input is invalid', () async {
      //arrange
      when(mockConverter.getUnsignedInteger(any))
          .thenReturn(Left(InputFailure()));
      final expected = [
        NumberTriviaInitial(),
        NumberTriviaError(INVALID_INPUT_FAILURE_MESSAGE),
      ];
      //act

      bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      //assert later
      await expectLater(bloc, emitsInOrder(expected));
    });

    test('Should get concrete trivia from usecase', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockConcrete(any)).thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        // NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaLoaded(tNumberTrivia),
      ];

      //act
      bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      await untilCalled(mockConcrete(any));
      //assert later
      verify(mockConcrete(Params(number: tNumberParsed)));
      expectLater(bloc, emitsInOrder(expected));
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockConcrete(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      final expected = [
        // NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(SERVER_FAILURE_MESSAGE),
      ];
      //act
      bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      await untilCalled(mockConcrete(any));
      //assert
      verify(mockConcrete(Params(number: tNumberParsed)));
      expectLater(bloc, emitsInOrder(expected));
    });

    test(
        'Should emit [Loading, Error] when getting data fails with a proper message',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockConcrete(any))
          .thenAnswer((realInvocation) async => Left(CachFailure()));
      final expected = [
        // NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(CACHE_FAILURE_MESSAGE),
      ];
      //act
      bloc.add(GetConcreteNumberTriviaEvent(tNumberString));
      await untilCalled(mockConcrete(any));
      //assert
      verify(mockConcrete(Params(number: tNumberParsed)));
      expectLater(bloc, emitsInOrder(expected));
    });
  });

  group('GetRandomNumberTrivia', () {
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');
    test('Should get concrete trivia from usecase', () async {
      //arrange
      when(mockRandom(any)).thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        // NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaLoaded(tNumberTrivia),
      ];

      //act
      bloc.add(GetRandomNumberTriviaEvent());
      await untilCalled(mockRandom(any));
      //assert later
      verify(mockRandom(NoParams()));
      expectLater(bloc, emitsInOrder(expected));
    });

    test(
        'Should emit [Loading, Error] when getting data fails with a proper message',
        () async {
      //arrange
      when(mockRandom(any)).thenAnswer((_) async => Left(CachFailure()));
      final expected = [
        // NumberTriviaInitial(),
        NumberTriviaLoading(),
        NumberTriviaError(CACHE_FAILURE_MESSAGE),
      ];
      //act
      bloc.add(GetRandomNumberTriviaEvent());
      await untilCalled(mockRandom(any));
      //assert
      verify(mockRandom(NoParams()));
      expectLater(bloc, emitsInOrder(expected));
    });
  });
}
