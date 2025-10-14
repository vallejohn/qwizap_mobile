import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'generated_content_exception.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure{
  const factory Failure.generateContent(GeneratedContentException genContent) = _GenerateContentException;
  const factory Failure.genAIException(GenerativeAIException genAIException) = _GenerativeAIException;
}