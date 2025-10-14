part of 'generate_bloc.dart';

enum GenerateFetchStatus {initial, loading, success, failure, finished}
enum GenerateCreateStatus {initial, loading, success, failure}
enum GenerateUpdateStatus {initial, loading, success, failure}
enum GenerateDeleteStatus {initial, loading, success, failure}

@freezed
class GenerateState with _$GenerateState {
  const factory GenerateState({
    @Default(GenerateFetchStatus.initial) GenerateFetchStatus fetchStatus,
    @Default(GenerateCreateStatus.initial) GenerateCreateStatus createStatus,
    @Default(GenerateUpdateStatus.initial) GenerateUpdateStatus updateStatus,
    @Default(GenerateDeleteStatus.initial) GenerateDeleteStatus deleteStatus,
    @Default('') String message,
    @Default([]) List<Question> data,
    Question? currentQuestion,
    @Default(0) int totalScore
  }) = _GenerateState;
}

