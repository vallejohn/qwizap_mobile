import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_exception.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure{
  const factory Failure.apiException(ApiException exception) = _APIException;
}

