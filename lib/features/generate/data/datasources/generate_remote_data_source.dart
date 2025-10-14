 import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';

import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../core/params/generate_params.dart';
import '../models/generate_model.dart';

abstract class GenerateRemoteDataSource {
  Future<GenerateOperationResult> fetch(GenerateFetchParams param);
  Future<bool> create(GenerateCreateParams param);
  Future<bool> update(GenerateUpdateParams param);
  Future<bool> delete(GenerateDeleteParams param);
}

class GenerateRemoteDataSourceImpl implements GenerateRemoteDataSource {
  final apiService = ApiService();

  @override
  Future<GenerateOperationResult> fetch(GenerateFetchParams param) async {
    final category = param.category.isNotEmpty? param.category : 'General School Topics';

    final response = await apiService.post(
      ApiEndpoints.fetchGenerate,
      data: {
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text": "Generate ${param.noOfItems} multiple-choice questions about $category. Each question must have 4 choices, one correct answer, an 'answer' field with the correct text, an 'explanation', and a 'difficulty' level. Return only valid JSON according to the schema."
              }
            ]
          }
        ],
        "generationConfig": {
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "ARRAY",
            "items": {
              "type": "OBJECT",
              "properties": {
                "id": { "type": "STRING" },
                "question": { "type": "STRING" },
                "choices": {
                  "type": "ARRAY",
                  "items": { "type": "STRING" },
                  "minItems": 4
                },
                "correctIndex": { "type": "INTEGER" },
                "answer": { "type": "STRING" },
                "explanation": { "type": "STRING" },
                "difficulty": {
                  "type": "STRING",
                  "enum": ["easy", "medium", "hard"]
                }
              },
              "required": ["id", "question", "choices", "correctIndex", "answer", "explanation", "difficulty"],
              "propertyOrdering": [
                "id",
                "question",
                "choices",
                "correctIndex",
                "answer",
                "explanation",
                "difficulty"
              ]
            }
          },
          "temperature": 0.2,
          "maxOutputTokens": 2048
        }
      }
    );

    final rawParts = response.data['candidates'][0]['content']['parts'][0]['text'];
    final parts = jsonDecode(rawParts);

    return GenerateOperationResult.success(
      data: (parts as List).map((q) => Question(
        question: q['question'],
        choices: (q['choices'] as List).map((c) => c.toString()).toList(),
        answer: q['answer'],
        difficulty: q['difficulty'],
      )).toList(),
    );
  }

  @override
  Future<bool> create(GenerateCreateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.createGenerate,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> update(GenerateUpdateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.updateGenerate,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> delete(GenerateDeleteParams param) async {
    final response = await apiService.post(
      ApiEndpoints.deleteGenerate,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }
}

