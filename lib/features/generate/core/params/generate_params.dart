import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';

import '../../../../core/models/operation_result.dart';
import '../../data/models/generate_model.dart';
part 'generate_params.freezed.dart';
part 'generate_params.g.dart';

typedef GenerateOperationResult = OperationResult<List<Question>>;

@freezed
class GenerateFetchParams with _$GenerateFetchParams {
  const factory GenerateFetchParams({
    //Modify this to your needs
    @Default(10) int noOfItems,
    required String category,
  }) = _GenerateFetchParams;

  factory GenerateFetchParams.fromJson(Map<String, dynamic> json) =>
      _$GenerateFetchParamsFromJson(json);
}

@freezed
class GenerateCreateParams with _$GenerateCreateParams {
  const factory GenerateCreateParams({
    //Modify this to your needs
    required String id,
  }) = _GenerateCreateParams;

  factory GenerateCreateParams.fromJson(Map<String, dynamic> json) =>
      _$GenerateCreateParamsFromJson(json);
}

@freezed
class GenerateUpdateParams with _$GenerateUpdateParams {
  const factory GenerateUpdateParams({
    //Modify this to your needs
    required String id,
  }) = _GenerateUpdateParams;

  factory GenerateUpdateParams.fromJson(Map<String, dynamic> json) =>
      _$GenerateUpdateParamsFromJson(json);
}

@freezed
class GenerateDeleteParams with _$GenerateDeleteParams {
  const factory GenerateDeleteParams({
    //Modify this to your needs
    required String id,
  }) = _GenerateDeleteParams;

  factory GenerateDeleteParams.fromJson(Map<String, dynamic> json) =>
      _$GenerateDeleteParamsFromJson(json);
}


