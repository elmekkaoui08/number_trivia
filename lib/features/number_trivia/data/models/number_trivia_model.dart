import 'package:meta/meta.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  NumberTriviaModel({
    @required int number,
    @required String text,
  }) : super(
          numberTrivia: number,
          textTrivia: text,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
        number: (json['number'] as num).toInt(),
        text: json['text'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapToJson = {
      "number": numberTrivia,
      "text": textTrivia
    };
    return mapToJson;
  }
}
