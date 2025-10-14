part of 'quiz_bloc.dart';

@freezed
class QuizEvent with _$QuizEvent {
  const factory QuizEvent.started() = _Started;
  const factory QuizEvent.generateQuestions(
    QuestionCategory category,
  ) = _GenerateQuestions;
  const factory QuizEvent.nextQuestion() = _NextQuestion;
  const factory QuizEvent.onAnswerSelected({
    required String answer,
    required int remainingTime,
    required int duration,
  }) = _OnAnswerSelected;
}
