part of 'categories_bloc.dart';

@freezed
class CategoriesEvent with _$CategoriesEvent {
  const factory CategoriesEvent.fetch(CategoriesFetchParams param) = _Fetch;
  const factory CategoriesEvent.create(CategoriesCreateParams param) = _Create;
  const factory CategoriesEvent.update(CategoriesUpdateParams param) = _Update;
  const factory CategoriesEvent.delete(CategoriesDeleteParams param) = _Delete;
}
