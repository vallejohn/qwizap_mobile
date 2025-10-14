import 'package:freezed_annotation/freezed_annotation.dart';
part 'level.freezed.dart';
part 'level.g.dart';

@freezed
class Level with _$Level {
  factory Level({
    @Default(0) int no,
    @Default(0) int requiredXP,
    @Default([]) List<int> perQuestionXP,
    @Default(0) int bonusXP,
    @Default(0) int duration,
    @Default(0) int noOfQuestions,
  }) = _Level;

  factory Level.fromJson(Map<String, dynamic> json) =>
      _$LevelFromJson(json);
}