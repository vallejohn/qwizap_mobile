import 'package:freezed_annotation/freezed_annotation.dart';
part 'generate_model.freezed.dart';
part 'generate_model.g.dart';

@freezed
class GenerateModel with _$GenerateModel {
  const factory GenerateModel({
    String? id,
    @Default('') String name,
  }) = _GenerateModel;

  factory GenerateModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateModelFromJson(json);
}
