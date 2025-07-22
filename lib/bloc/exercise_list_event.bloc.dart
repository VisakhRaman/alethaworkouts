import 'package:equatable/equatable.dart';

abstract class ExerciseListEvent extends Equatable {
  const ExerciseListEvent();

  @override
  List<Object> get props => [];
}

class FetchExercises extends ExerciseListEvent {}

class UpdateExerciseCompletion extends ExerciseListEvent {
  final String exerciseId;

  const UpdateExerciseCompletion(this.exerciseId);

  @override
  List<Object> get props => [exerciseId];
}