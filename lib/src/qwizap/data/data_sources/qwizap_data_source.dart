import '../../../../core/services/gemini/gemini_service.dart';
import '../../core/params/multiple_choice_params.dart';
import '../models/question_model.dart';

abstract class QwizapDataSource {
  final GeminiService geminiService;

  QwizapDataSource(this.geminiService);

  Future<List<Question>> createMultipleChoiceQuestions(MultipleChoiceParam params);
}
