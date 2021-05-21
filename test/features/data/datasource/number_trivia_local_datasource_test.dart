import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreference mockSharedPreference;
  NumberTriviaLocalDatasourceImpl localDatasource;

  setUp(() {
    mockSharedPreference = MockSharedPreference();
    localDatasource = NumberTriviaLocalDatasourceImpl(mockSharedPreference);
  });

  group('getLastNumberTrivia', () {
    test('Should Return the last stored trivia from the cached prefences',
        () async {
      //arrange
      final tNumberTrivia =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
      when(mockSharedPreference.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await localDatasource.getLastNumberTrivia();
      //assert
      verify(mockSharedPreference.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTrivia);
    });

    //TODO: must be checked (NOT WORKING)
    // test('Should throw a CachException if no data found on SharedPreferences',
    //     () async {
    //   //arrange
    //   when(mockSharedPreference.getString(any)).thenReturn(null);
    //   //act
    //   final call = localDatasource.getLastNumberTrivia;
    //   //assert
    //   // verify(mockSharedPreference.getString(CACHED_NUMBER_TRIVIA));
    //   // ignore: deprecated_member_use
    //   expect(() => call(), throwsA(TypeMatcher<CachException>()));
    // });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () {
      // act
      localDatasource.cachNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreference.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
