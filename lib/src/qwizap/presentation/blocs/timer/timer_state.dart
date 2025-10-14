part of 'timer_bloc.dart';

@freezed
class TimerState with _$TimerState {
  const factory TimerState.initial(int duration) = TimerInitial;
  const factory TimerState.runInProgress(int duration) = TimerRunInProgress;
  const factory TimerState.runPause(int duration) = TimerRunPause;
  const factory TimerState.runComplete() = TimerRunComplete;
}
