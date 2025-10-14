import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_category.dart';

import '../../../../core/models/operation_result.dart';
import '../../data/models/categories_model.dart';
part 'categories_params.freezed.dart';
part 'categories_params.g.dart';

typedef CategoriesOperationResult = OperationResult<List<QuestionCategory>>;

@freezed
class CategoriesFetchParams with _$CategoriesFetchParams {
  const factory CategoriesFetchParams({
    //Modify this to your needs
    required String id,
  }) = _CategoriesFetchParams;

  factory CategoriesFetchParams.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFetchParamsFromJson(json);
}

@freezed
class CategoriesCreateParams with _$CategoriesCreateParams {
  const factory CategoriesCreateParams({
    //Modify this to your needs
    required String id,
  }) = _CategoriesCreateParams;

  factory CategoriesCreateParams.fromJson(Map<String, dynamic> json) =>
      _$CategoriesCreateParamsFromJson(json);
}

@freezed
class CategoriesUpdateParams with _$CategoriesUpdateParams {
  const factory CategoriesUpdateParams({
    //Modify this to your needs
    required String id,
  }) = _CategoriesUpdateParams;

  factory CategoriesUpdateParams.fromJson(Map<String, dynamic> json) =>
      _$CategoriesUpdateParamsFromJson(json);
}

@freezed
class CategoriesDeleteParams with _$CategoriesDeleteParams {
  const factory CategoriesDeleteParams({
    //Modify this to your needs
    required String id,
  }) = _CategoriesDeleteParams;

  factory CategoriesDeleteParams.fromJson(Map<String, dynamic> json) =>
      _$CategoriesDeleteParamsFromJson(json);
}


