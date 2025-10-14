import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:qwizap_mobile/core/exceptions_old/failure.dart';
import 'package:qwizap_mobile/core/exceptions_old/generated_content_exception.dart';
import 'package:qwizap_mobile/src/qwizap/core/params/multiple_choice_params.dart';

import '../../domain/repositories/qwizap_repository.dart';

class QwizapRepositoryImpl extends QwizapRepository {
  QwizapRepositoryImpl({required super.dataSource});

  @override
  Future<EitherListQuestions> createMultipleChoiceQuestions(
    MultipleChoiceParam params,
  ) async {
    try {
      final data = await dataSource.createMultipleChoiceQuestions(params);
      return Right(data);
    } on GeneratedContentException catch (genContentException) {
      return Left(Failure.generateContent(genContentException));
    } on GenerativeAIException catch (genAIException) {
      return Left(Failure.genAIException(genAIException));
    }
  }
}
