part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super([props]);
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent(this.numberString) : super([numberString]);
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {}
