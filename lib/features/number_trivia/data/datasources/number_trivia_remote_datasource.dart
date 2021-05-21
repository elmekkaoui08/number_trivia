import 'dart:convert';

import 'package:number_trivia/core/errors/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

const String URL = 'http://numbersapi.com/';
const Object HEADERS = {'Content-Type': 'application/json'};

abstract class NumberTriviaRemoteDatasource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final trivia = await _getTriviaFromURL(number.toString());
    print('----------------- $trivia ----------------');
    return trivia;
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromURL('random');
  }

  Future<NumberTriviaModel> _getTriviaFromURL(String param) async {
    final http.Response jsonResponse =
        await client.get(URL + param, headers: HEADERS);
    if (jsonResponse.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(jsonResponse.body));
    } else {
      throw ServerException();
    }
  }
}
