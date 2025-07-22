import 'package:equatable/equatable.dart';

abstract class ExerciseDetailState extends Equatable {
  const ExerciseDetailState();

  @override
  List<Object> get props => [];
}

class ExerciseDetailInitial extends ExerciseDetailState {}

class ExerciseTimerRunning extends ExerciseDetailState {
  final int remainingSeconds;

  const ExerciseTimerRunning(this.remainingSeconds);

  @override
  List<Object> get props => [remainingSeconds];
}

class ExerciseTimerCompleted extends ExerciseDetailState {
  final String exerciseId;

  const ExerciseTimerCompleted(this.exerciseId);

  @override
  List<Object> get props => [exerciseId];
}