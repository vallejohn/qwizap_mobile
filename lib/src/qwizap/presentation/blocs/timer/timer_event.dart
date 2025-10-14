part of 'timer_bloc.dart';

@freezed
class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started(int duration) = TimerStarted;
  const factory TimerEvent.paused() = TimerPaused;
  const factory TimerEvent.resumed() = TimerResumed;
  const factory TimerEvent.reset() = TimerReset;
  const factory TimerEvent.ticked(int duration) = TimerTicked;
}
