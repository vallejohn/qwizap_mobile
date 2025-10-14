part of 'generate_bloc.dart';

@freezed
class GenerateEvent with _$GenerateEvent {
  const factory GenerateEvent.fetch(GenerateFetchParams param) = _Fetch;
  const factory GenerateEvent.create(GenerateCreateParams param) = _Create;
  const factory GenerateEvent.update(GenerateUpdateParams param) = _Update;
  const factory GenerateEvent.delete(GenerateDeleteParams param) = _Delete;
  const factory GenerateEvent.nextQuestion() = _NextQuestion;
  const factory GenerateEvent.onAnswerSelected({
    required String answer,
    required int remainingTime,
    required int duration,
  }) = _OnAnswerSelected;
}
