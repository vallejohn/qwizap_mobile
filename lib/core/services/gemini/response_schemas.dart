import 'package:google_generative_ai/google_generative_ai.dart';

class ResponseSchemas{
  static Schema multipleChoiceSchema(){
    return  Schema.object(properties: {
      'questions': Schema.array(
          items: Schema.object(properties: {
            'question': Schema.string(
              description: 'question',
              nullable: false,
            ),
            'choices': Schema.array(
                items: Schema.string(
                  description: 'choices',
                  nullable: false,
                )),
            'answer': Schema.string(
              description: 'Answer',
              nullable: false,
            ),
          }))
    });
  }
}