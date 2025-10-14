import 'package:qwizap_mobile/src/qwizap/domain/repositories/qwizap_repository.dart';

import '../../../../core/use_case_old.dart';
import '../../core/params/multiple_choice_params.dart';
import '../../data/models/question_model.dart';

typedef _GenMultiChoice
    = UseCaseWithParams<List<Question>, MultipleChoiceParam>;

class GenerateMultipleChoiceQuestions implements _GenMultiChoice {
  final QwizapRepository _qwizapRepository;

  GenerateMultipleChoiceQuestions(this._qwizapRepository);

  @override
  Future<EitherListQuestions> call(MultipleChoiceParam param) {
    return _qwizapRepository.createMultipleChoiceQuestions(param);
  }
}
