import 'package:equatable/equatable.dart';

abstract class ExerciseDetailEvent extends Equatable {
  const ExerciseDetailEvent();

  @override
  List<Object> get props => [];
}

class StartExerciseTimer extends ExerciseDetailEvent {
  final int duration;
  final String exerciseId;

  const StartExerciseTimer(this.duration, this.exerciseId);

  @override
  List<Object> get props => [duration, exerciseId];
}

class TimerTick extends ExerciseDetailEvent {
  final int remainingSeconds;

  const TimerTick(this.remainingSeconds);

  @override
  List<Object> get props => [remainingSeconds];
}

class TimerCompleted extends ExerciseDetailEvent {
  final String exerciseId;

  const TimerCompleted(this.exerciseId);

  @override
  List<Object> get props => [exerciseId];
}

class ResetExerciseDetail extends ExerciseDetailEvent {}