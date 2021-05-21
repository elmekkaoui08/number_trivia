import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/presentation/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('Should convert a string to a number and return the number', () async {
    //arrange
    String number = '123';
    //act
    final result = inputConverter.getUnsignedInteger(number);
    //assert
    expect(result, Right(123));
  });

  test('Should return an exception if the number is negative ', () async {
    //arrange
    final number = '123.9';
    //act
    final result = inputConverter.getUnsignedInteger(number);
    //assert
    expect(result, Left(InputFailure()));
  });

  test('Should return an exception if the string isnt a number ', () async {
    //arrange
    final number = '14RFV';
    //act
    final result = inputConverter.getUnsignedInteger(number);
    //assert
    expect(result, Left(InputFailure()));
  });
}
