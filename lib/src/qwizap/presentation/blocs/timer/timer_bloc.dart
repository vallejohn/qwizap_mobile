import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_event.dart';
part 'timer_state.dart';
part 'timer_bloc.freezed.dart';

class Ticker {
  Stream<int> tick(int ticks) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }
}

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc(Ticker ticker) : _ticker = ticker, super(const TimerState.initial(60)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerState.runInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(event.duration).listen(
          (duration) => add(TimerEvent.ticked(duration)),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    state.maybeWhen(
      runInProgress: (duration) {
        _tickerSubscription?.pause();
        emit(TimerState.runPause(duration));
      },
      orElse: () {},
    );
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    state.maybeWhen(
      runPause: (duration) {
        _tickerSubscription?.resume();
        emit(TimerState.runInProgress(duration));
      },
      orElse: () {},
    );
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerState.initial(60));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerState.runInProgress(event.duration)
        : const TimerState.runComplete());
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
