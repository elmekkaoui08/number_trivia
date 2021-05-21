part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List<Object> props]) : super([props]);

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTriviaEntity numberTriviaEntity;

  NumberTriviaLoaded(this.numberTriviaEntity) : super([numberTriviaEntity]);
}

class NumberTriviaError extends NumberTriviaState {
  final String errMsg;

  NumberTriviaError(this.errMsg) : super([errMsg]);
}
