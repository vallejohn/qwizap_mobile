part of 'category_selection_bloc.dart';

@freezed
class CategorySelectionEvent with _$CategorySelectionEvent {
  const factory CategorySelectionEvent.onInitCategories() = _OnInitCategories;
  const factory CategorySelectionEvent.onSelectCategory(
    QuestionCategory category,
  ) = _OnSelectCategory;
}
