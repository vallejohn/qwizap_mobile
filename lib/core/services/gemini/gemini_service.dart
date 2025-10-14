import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../src/qwizap/data/models/question_model.dart';
import '../../exceptions_old/generated_content_exception.dart';
import 'content_prompt.dart';

enum ContentType {multipleChoice}

class GeminiService {
  late GenerativeModel _model;

  void init()async {
    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: dotenv.env['GEMINI_API_KEY']?? '',
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
    );
  }

  Future<Map<String, dynamic>> generateContent(ContentType contentType,{
    int questionCount = 5,
    required String topic,
    int noOfChoices = 4,
    required int level,
  }) async {

/*    await Future.delayed(const Duration(seconds: 3));

    List<Question> _questions = [
      const Question(
        question: 'What is the third planet from the Sun?',
        choices: [
          'Mars',
          'Venus',
          'Earth',
          'Jupiter',
        ],
        answer: 'Earth',
      ),
      const Question(
        question: "What percentage of the Earth's surface is covered by water?",
        choices: [
          '29%',
          '50%',
          '71%',
          '90%',
        ],
        answer: '71%',
      ),
    ];

    final data = _questions.map((toElement) => toElement.toJson()).toList();
    final map = {'questions': data};
    return map;*/

    late List<Content> content;
    switch(contentType){
      case ContentType.multipleChoice:
        content = ContentPrompt.multipleChoicePrompts(
          topic: topic,
          questionCount: questionCount,
          noOfChoices: noOfChoices,
          level: level
        );
    }

    final contentResponse = await _model.generateContent(content);

    try{
      if(contentResponse.text != null){
        final decodedData = jsonDecode(contentResponse.text!);
        Logger().i(decodedData);
        return decodedData;
      }else{
         throw emptyTextResponse();
      }
    }catch (_){
      throw invalidGeneratedFormat();
    }
  }
}
