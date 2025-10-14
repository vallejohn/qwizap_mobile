import 'package:qwizap_mobile/core/services/gemini/gemini_service.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';

import '../../core/params/multiple_choice_params.dart';
import 'qwizap_data_source.dart';

/// This class is responsible for retrieving data from remote
/// sources like REST APIs, Amplify, Firebase etc.
class QwizapRemoteDataSourceImpl extends QwizapDataSource {
  QwizapRemoteDataSourceImpl(super.geminiService);

  @override
  Future<List<Question>> createMultipleChoiceQuestions(
    MultipleChoiceParam params,
  )async {
    final result = await geminiService.generateContent(
      ContentType.multipleChoice,
      topic: params.topic,
      noOfChoices: params.noOfChoices,
      questionCount: params.questionCount,
      level: params.level,
    );

    return (result['questions'] as List).map((e){
      return Question.fromJson(e);
    }).toList();
  }
}
