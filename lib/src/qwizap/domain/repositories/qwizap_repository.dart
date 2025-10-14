import 'package:dartz/dartz.dart';
import 'package:qwizap_mobile/core/exceptions_old/failure.dart';

import '../../core/params/multiple_choice_params.dart';
import '../../data/data_sources/qwizap_data_source.dart';
import '../../data/models/question_model.dart';

typedef EitherListQuestions = Either<Failure, List<Question>>;

abstract class QwizapRepository {
  final QwizapDataSource dataSource;

  QwizapRepository({required this.dataSource});

  Future<EitherListQuestions> createMultipleChoiceQuestions(
    MultipleChoiceParam params,
  );
}
