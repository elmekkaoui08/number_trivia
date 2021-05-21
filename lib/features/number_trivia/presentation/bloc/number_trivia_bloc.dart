import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/presentation/util/input_converter.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required InputConverter converter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(converter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter,
        super(NumberTriviaInitial());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetConcreteNumberTriviaEvent) {
      yield NumberTriviaInitial();
      final either = inputConverter.getUnsignedInteger(event.numberString);

      yield* either.fold((failure) async* {
        print('Error -----------------> ');
        yield NumberTriviaError(_mapMessageToError(failure));
      }, (integer) async* {
        yield NumberTriviaLoading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield failureOrTrivia.fold(
          (l) {
            return NumberTriviaError(SERVER_FAILURE_MESSAGE);
          },
          (r) => NumberTriviaLoaded(r),
        );
      });
    } else if (event is GetRandomNumberTriviaEvent) {
      yield NumberTriviaInitial();
      yield NumberTriviaLoading();
      final failureOrFTrivia = await getRandomNumberTrivia(NoParams());

      yield* failureOrFTrivia.fold(
        (l) async* {
          yield NumberTriviaError(SERVER_FAILURE_MESSAGE);
        },
        (r) async* {
          yield NumberTriviaLoaded(r);
        },
      );
    }
  }

  @override
  NumberTriviaState get initialState => NumberTriviaInitial();
}

String _mapMessageToError(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
      break;
    case CachFailure:
      return CACHE_FAILURE_MESSAGE;
      break;
    case InputFailure:
      return INVALID_INPUT_FAILURE_MESSAGE;
      break;
    default:
      return 'Unexpected Error';
  }
}
