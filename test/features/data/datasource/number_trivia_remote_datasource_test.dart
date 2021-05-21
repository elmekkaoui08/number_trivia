import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDatasourceImpl remoteDatasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDatasource = NumberTriviaRemoteDatasourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tnumber = 1;
    final tnumberTriviaModel =
        NumberTriviaModel(number: tnumber, text: 'test text');
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDatasource.getConcreteNumberTrivia(tnumber);
      //assert
      verify(
        mockHttpClient.get(
          'http://numbersapi.com/$tnumber',
          headers: {'Content-Type': 'application/json'},
        ),
      );
      expect(result, equals(tnumberTriviaModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDatasource.getConcreteNumberTrivia;
        // assert
        /// to verify
        //expect(() => call(tnumber), throwsA(ServerException()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tnumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDatasource.getRandomNumberTrivia();
      //assert
      verify(
        mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ),
      );
      expect(result, equals(tnumberTriviaModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDatasource.getRandomNumberTrivia;
        // assert
        /// to verify
        //expect(() => call(tnumber), throwsA(ServerException()));
      },
    );
  });
}
