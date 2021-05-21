import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NumberTriviaEntity extends Equatable {
  final int numberTrivia;
  final String textTrivia;
  NumberTriviaEntity({
    @required this.numberTrivia,
    @required this.textTrivia,
  }) : super([numberTrivia, textTrivia]);
}
