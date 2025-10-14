import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';
import '../../core/params/generate_params.dart';
import '../../data/models/generate_model.dart';
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
      emit(state.copyWith(
        fetchStatus: GenerateFetchStatus.finished,
      ));
    }
  }

  Future<void> _onAnswerSelected(
      _OnAnswerSelected event, Emitter<GenerateState> emit)async {
    int baseScore = 100;
    Question currentQuestion =
    state.currentQuestion!.copyWith(selectedAnswer: event.answer);

    ///Calculate score
    bool correctAnswer =
        currentQuestion.selectedAnswer == currentQuestion.answer;
    double itemCompletionRate = (event.remainingTime / event.duration) * 100;
    double timeScore = ((itemCompletionRate / 100) * baseScore);

    int totalItemScore = !correctAnswer
        ? 0
        : int.parse((baseScore + timeScore).toStringAsFixed(0));

    if(correctAnswer){

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

