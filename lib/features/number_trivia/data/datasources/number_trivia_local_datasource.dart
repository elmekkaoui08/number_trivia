import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cachNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> cachNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(numberTriviaModel.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (json != null)
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    else
      throw CachException();
  }
}
