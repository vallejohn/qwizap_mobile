import 'package:qwizap_mobile/src/qwizap/core/params/multiple_choice_params.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';

import 'qwizap_data_source.dart';

/// This class is responsible for retrieving data from local 
/// sources like SQFlite, Hive etc.
class QwizapLocalDataSourceImpl extends QwizapDataSource{
  QwizapLocalDataSourceImpl(super.geminiService);

  @override
  Future<List<Question>> createMultipleChoiceQuestions(MultipleChoiceParam params) {
    // TODO: implement createMultipleChoiceQuestions
    throw UnimplementedError();
  }

}
