import 'package:google_generative_ai/google_generative_ai.dart';

class ContentPrompt {
  static List<Content> multipleChoicePrompts({
    required int questionCount,
    required String topic,
    required int noOfChoices,
    required int level,
  }) {
    return [
      Content.multi([
        TextPart('Create $questionCount $topic multiple choice questions with $noOfChoices choices and also provide the answer'),
        TextPart('The current level is $level'),
        TextPart('Each question should have a difficulty based on the level provider'),
        TextPart('We have 3 types of difficulties which is the easy, medium and hard'),
        TextPart('If the level provided is 1, please provide easy questions only'),
        TextPart('If the level provided is between 2 and 3, please provide easy and medium questions randomly'),
        TextPart('If the level provided is between 4 and 5, please provide the 3 types of difficulty questions randomly'),
        TextPart('If the level provided is 6 and above, please provide the medium and hard questions randomly'),
      ]),
      Content.model([
        TextPart('```json\n{"questions": [{"difficulty": "easy", "question": "What is the capital of Australia?", "choices": ["Sydney", "Melbourne", "Canberra", "Brisbane"], "answer": "Canberra"}, {"difficulty": "easy", "question": "What is the largest planet in our solar system?", "choices": ["Mars", "Jupiter", "Saturn", "Earth"], "answer": "Jupiter"}, {"difficulty": "easy", "question": "What is the chemical symbol for gold?", "choices": ["Ag", "Au", "Fe", "Hg"], "answer": "Au"}]}\n\n```'),
      ]),
    ];
  }
}
