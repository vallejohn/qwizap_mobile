part of 'category_selection_bloc.dart';

enum CategorySelectionStatus { initial, loading, success, failed }

@freezed
class CategorySelectionState with _$CategorySelectionState {
  const factory CategorySelectionState({
    @Default(CategorySelectionStatus.initial) CategorySelectionStatus status,
    @Default([]) List<QuestionCategory> categories,
    QuestionCategory? selectedCategory,
    @Default('') String message,
  }) = _CategorySelectionState;
}
