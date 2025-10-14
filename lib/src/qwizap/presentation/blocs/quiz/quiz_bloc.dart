import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:qwizap_mobile/core/services/level_manager.dart';
import 'package:qwizap_mobile/src/qwizap/core/params/multiple_choice_params.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_category.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';
import 'package:qwizap_mobile/src/qwizap/domain/usecases/generate_multiple_choice_questions_usecase.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';
part 'quiz_bloc.freezed.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final _genQuestions = GetIt.instance<GenerateMultipleChoiceQuestions>();
  late final int _baseScore;
  late final LevelManager _levelManager;

  QuizBloc({
    int baseScore = 100,
    required LevelManager levelManager
  })  : _baseScore = baseScore, _levelManager = levelManager,
        super(const QuizState()) {
    on<_GenerateQuestions>(_generateQuestions);
    on<_NextQuestion>(_nextQuestion);
    on<_OnAnswerSelected>(_onAnswerSelected);
  }

  FutureOr<void> _generateQuestions(
    _GenerateQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(
      status: QuizStatus.loading,
    ));

    final level = _levelManager.levels.where((e){
      return e.no == _levelManager.currentLevel;
    }).first;

    final data = await _genQuestions(MultipleChoiceParam(
      topic: event.category.name,
      questionCount: level.noOfQuestions,
      level: _levelManager.currentLevel,
    ));

    data.fold((error) {
      emit(
        state.copyWith(
          status: QuizStatus.failed,
          message: error.maybeWhen(
            generateContent: (e) => e.message,
            genAIException: (e) => e.message,
            orElse: () => '',
          ),
        ),
      );
    }, (data) {
      emit(state.copyWith(
          status: QuizStatus.success,
          questions: data,
          currentQuestion: data.first));
    });
  }

  FutureOr<void> _nextQuestion(_NextQuestion event, Emitter<QuizState> emit) {
    final index = state.questions
        .indexWhere((e) => e.question == state.currentQuestion!.question);

    if (index >= 0 && (index + 1) < state.questions.length) {
      final nextIndex = index + 1;
      final nextQuestion = state.questions[nextIndex];
      emit(state.copyWith(currentQuestion: nextQuestion));
    }else{
      emit(state.copyWith(
        status: QuizStatus.finished,
      ));
    }
  }

  FutureOr<void> _onAnswerSelected(
      _OnAnswerSelected event, Emitter<QuizState> emit) {
    Question currentQuestion =
        state.currentQuestion!.copyWith(selectedAnswer: event.answer);

    ///Calculate score
    bool correctAnswer =
        currentQuestion.selectedAnswer == currentQuestion.answer;
/*    double itemCompletionRate = (event.remainingTime / event.duration) * 100;
    double timeScore = ((itemCompletionRate / 100) * _baseScore);

    int totalItemScore = !correctAnswer
        ? 0
        : int.parse((_baseScore + timeScore).toStringAsFixed(0));*/

    int totalItemScore = 0;

    if(correctAnswer){

    }

    currentQuestion = currentQuestion.copyWith(score: totalItemScore);

    final questions = [...state.questions];
    final index = questions.indexWhere((e) {
      return e.question == currentQuestion.question;
    });
    questions[index] = currentQuestion;

    emit(state.copyWith(
      currentQuestion: currentQuestion,
      questions: questions,
    ));
  }

  @override
  void onChange(Change<QuizState> change) {
    // TODO: implement onChange
    super.onChange(change);

    final log = Logger();

    final data = change.nextState.questions.map((toElement) => toElement.toJson()).toList();
    log.i(data);
  }
}
