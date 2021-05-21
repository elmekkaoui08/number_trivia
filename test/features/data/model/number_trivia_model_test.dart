import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final numberTriviaModel =
      NumberTriviaModel(number: 1, text: 'the world best number');
  group('fromJson', () {
    test('Should return the trivia from json file', () {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, numberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should convert the number trivia object to a json object', () {
      //arrange
      final expectedJosn = {"number": 1, "text": "the world best number"};
      //act
      final result = numberTriviaModel.toJson();
      //assert
      expect(result, expectedJosn);
    });
  });
}
