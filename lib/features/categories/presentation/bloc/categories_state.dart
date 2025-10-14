part of 'categories_bloc.dart';

enum CategoriesFetchStatus {initial, loading, success, failure}
enum CategoriesCreateStatus {initial, loading, success, failure}
enum CategoriesUpdateStatus {initial, loading, success, failure}
enum CategoriesDeleteStatus {initial, loading, success, failure}

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(CategoriesFetchStatus.initial) CategoriesFetchStatus fetchStatus,
    @Default(CategoriesCreateStatus.initial) CategoriesCreateStatus createStatus,
    @Default(CategoriesUpdateStatus.initial) CategoriesUpdateStatus updateStatus,
    @Default(CategoriesDeleteStatus.initial) CategoriesDeleteStatus deleteStatus,
    @Default('') String message,
    @Default([]) List<QuestionCategory> data,
  }) = _CategoriesState;
}

