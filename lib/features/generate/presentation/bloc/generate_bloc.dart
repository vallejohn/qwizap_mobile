import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';
import '../../core/params/generate_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/generate_usecase.dart';

part 'generate_event.dart';
part 'generate_state.dart';
part 'generate_bloc.freezed.dart';

class GenerateBloc extends Bloc<GenerateEvent, GenerateState> {
  final _fetchUseCase = GetIt.instance<GenerateFetchUseCase>();
  final _createUseCase = GetIt.instance<GenerateCreateUseCase>();
  final _updateUseCase = GetIt.instance<GenerateUpdateUseCase>();
  final _deleteUseCase = GetIt.instance<GenerateDeleteUseCase>();
  final _saveScoreUseCase = GetIt.instance<GenerateSaveScoreUseCase>();
  final _logger = Logger();

  GenerateBloc() : super(const GenerateState()) {
    on<_Fetch>(_onFetch);
    on<_NextQuestion>(_nextQuestion);
    on<_OnAnswerSelected>(_onAnswerSelected);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
  }

  Future<void> _onFetch(_Fetch event, Emitter<GenerateState> emit) async {
    emit(state.copyWith(fetchStatus: GenerateFetchStatus.loading));
    final result = await _fetchUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          fetchStatus: GenerateFetchStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(
        state.copyWith(
          fetchStatus: GenerateFetchStatus.success,
          data: data.data?? [],
          currentQuestion: data.data?.first,
          category: event.param.category,
        ),
      ),
    );
  }

  Future<void> _nextQuestion(_NextQuestion event, Emitter<GenerateState> emit) async {
    final index = state.data
        .indexWhere((e) => e.question == state.currentQuestion!.question);

    if (index >= 0 && (index + 1) < state.data.length) {
      final nextIndex = index + 1;
      final nextQuestion = state.data[nextIndex];
      emit(state.copyWith(currentQuestion: nextQuestion));
    }else{
      // Calculate total score and save it
      final totalScore = state.data.fold(0, (total, q) => total + q.score);
      
      // Save score if category is not empty
      if (state.category.isNotEmpty) {
        final saveResult = await _saveScoreUseCase(
          GenerateSaveScoreParams(
            category: state.category,
            score: totalScore,
          ),
        );
        // Log error but don't block UI flow if score saving fails
        saveResult.fold(
          (error) => null, // Error handling can be added here if needed
          (success) => null,
        );
      }
      
      emit(state.copyWith(
        fetchStatus: GenerateFetchStatus.finished,
        totalScore: totalScore,
      ));
    }
  }

  Future<void> _onAnswerSelected(
      _OnAnswerSelected event, Emitter<GenerateState> emit)async {
    const int baseScore = 100;
    const int maxTimeScore = 100; // Maximum bonus for answering quickly
    Question currentQuestion =
    state.currentQuestion!.copyWith(selectedAnswer: event.answer);

    ///Calculate score
    bool correctAnswer =
        currentQuestion.selectedAnswer == currentQuestion.answer;
    
    int totalItemScore = 0;
    
    if (correctAnswer) {
      // Clamp remainingTime to valid range [0, duration]
      final clampedRemainingTime = event.remainingTime.clamp(0, event.duration);
      
      _logger.d('Scoring calculation - remainingTime: ${event.remainingTime}, clamped: $clampedRemainingTime, duration: ${event.duration}');
      
      // Calculate elapsed time percentage of total duration
      final elapsedTime = event.duration - clampedRemainingTime;
      final elapsedTimePercentage = (elapsedTime / event.duration) * 100;
      
      // Use the elapsed time percentage to calculate the time score
      // Since we want to reward faster answers, we use remaining time percentage
      // which is the inverse of elapsed time percentage
      final remainingTimePercentage = 100 - elapsedTimePercentage;
      final timeScore = (remainingTimePercentage / 100) * maxTimeScore;
      totalItemScore = int.parse((baseScore + timeScore).toStringAsFixed(0));
      
      _logger.i('Scoring - elapsedTime: $elapsedTime, elapsedTimePercentage: ${elapsedTimePercentage.toStringAsFixed(2)}%, remainingTimePercentage: ${remainingTimePercentage.toStringAsFixed(2)}%, timeScore: ${timeScore.toStringAsFixed(2)}, totalItemScore: $totalItemScore');
    } else {
      _logger.d('Incorrect answer - score: 0');
    }

    currentQuestion = currentQuestion.copyWith(score: totalItemScore);

    final questions = [...state.data];
    final index = questions.indexWhere((e) {
      return e.question == currentQuestion.question;
    });
    questions[index] = currentQuestion;

    emit(state.copyWith(
      currentQuestion: currentQuestion,
      data: questions,
    ));
  }

  Future<void> _onCreate(_Create event, Emitter<GenerateState> emit) async {
    emit(state.copyWith(createStatus: GenerateCreateStatus.loading));
    final result = await _createUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          createStatus: GenerateCreateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(createStatus: GenerateCreateStatus.success)),
    );
  }

  Future<void> _onUpdate(_Update event, Emitter<GenerateState> emit) async {
    emit(state.copyWith(updateStatus: GenerateUpdateStatus.loading));
    final result = await _updateUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          updateStatus: GenerateUpdateStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(updateStatus: GenerateUpdateStatus.success)),
    );
  }

  Future<void> _onDelete(_Delete event, Emitter<GenerateState> emit) async {
    emit(state.copyWith(deleteStatus: GenerateDeleteStatus.loading));
    final result = await _deleteUseCase(event.param);
    result.fold(
      (error) => emit(
        state.copyWith(
          deleteStatus: GenerateDeleteStatus.failure,
          message: error.when(apiException: (e) => e.message),
        ),
      ),
      (data) => emit(state.copyWith(deleteStatus: GenerateDeleteStatus.success)),
    );
  }
}

