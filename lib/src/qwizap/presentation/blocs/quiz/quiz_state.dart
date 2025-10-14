part of 'quiz_bloc.dart';

enum QuizStatus {initial, loading, success, failed, finished}

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    @Default(QuizStatus.initial) QuizStatus status,
    @Default('') String message,
    @Default([]) List<Question> questions,
    Question? currentQuestion,
    @Default(0) int totalScore
  }) = _QuizState;
}
