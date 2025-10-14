import 'package:freezed_annotation/freezed_annotation.dart';
part 'question_category.freezed.dart';
part 'question_category.g.dart';

@freezed
class QuestionCategory with _$QuestionCategory {
  factory QuestionCategory({
    required String name,
    @Default([]) List<String> subcategories,
  }) = _QuestionCategory;

  factory QuestionCategory.fromJson(Map<String, dynamic> json) =>
      _$QuestionCategoryFromJson(json);
}