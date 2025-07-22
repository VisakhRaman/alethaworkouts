import 'dart:async';
import 'package:AlethaWorkouts/bloc/exercise_detail_state.bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exercise_detail_event.dart';

class ExerciseDetailBloc extends Bloc<ExerciseDetailEvent, ExerciseDetailState> {
  StreamSubscription<int>? _timerSubscription;
  String? _currentExerciseId;

  ExerciseDetailBloc() : super(ExerciseDetailInitial()) {
    on<StartExerciseTimer>(_onStartExerciseTimer);
    on<TimerTick>(_onTimerTick);
    on<TimerCompleted>(_onTimerCompleted);
    on<ResetExerciseDetail>(_onResetExerciseDetail);
  }

  void _onStartExerciseTimer(
    StartExerciseTimer event,
    Emitter<ExerciseDetailState> emit,
  ) {
    _currentExerciseId = event.exerciseId;
    _timerSubscription?.cancel(); // Cancel any existing timer

    int currentSeconds = event.duration;
    emit(ExerciseTimerRunning(currentSeconds));

    _timerSubscription = Stream.periodic(const Duration(seconds: 1), (count) => event.duration - (count + 1))
        .take(event.duration)
        .listen((remainingSeconds) {
      if (remainingSeconds >= 0) {
        add(TimerTick(remainingSeconds));
      }
    }, onDone: () {
      add(TimerCompleted(_currentExerciseId!));
    });
  }

  void _onTimerTick(
    TimerTick event,
    Emitter<ExerciseDetailState> emit,
  ) {
    emit(ExerciseTimerRunning(event.remainingSeconds));
  }

  void _onTimerCompleted(
    TimerCompleted event,
    Emitter<ExerciseDetailState> emit,
  ) {
    _timerSubscription?.cancel();
    emit(ExerciseTimerCompleted(event.exerciseId));
  }

  void _onResetExerciseDetail(
    ResetExerciseDetail event,
    Emitter<ExerciseDetailState> emit,
  ) {
    _timerSubscription?.cancel();
    _currentExerciseId = null;
    emit(ExerciseDetailInitial());
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}