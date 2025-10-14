import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class Question with _$Question {
  const factory Question({
    @Default('') String question,
    @Default([]) List<String> choices,
    @Default('') String answer,
    @Default('') String selectedAnswer,
    @Default(0) int score,
    @Default('') String difficulty,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
}